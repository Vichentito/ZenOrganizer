import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/blocs/finanzas_config_bloc/finanzas_config_bloc.dart';
import 'package:zen_organizer/presentation/blocs/plan_anual_bloc/plan_anual_bloc.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/quincena_item.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart';

class QuincenasView extends StatefulWidget {
  const QuincenasView({Key? key}) : super(key: key);

  @override
  QuincenasViewState createState() => QuincenasViewState();
}

class QuincenasViewState extends State<QuincenasView> {
  double sueldo = 0.0;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    // Asumiendo que los Blocs están disponibles en el árbol de widgets
    context.read<PlanAnualBloc>().add(LoadPlanesAnuales());
    context.read<FinanzasConfigBloc>().add(LoadConfig());
  }

  @override
  Widget build(BuildContext context) {
    final salarioBloc = BlocProvider.of<FinanzasConfigBloc>(context);
    final salarioState = salarioBloc.state;

    if (salarioState is FinanzasConfigLoaded) {
      sueldo = salarioState.config.sueldo;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quincenas'),
        actions: <Widget>[
          BlocBuilder<PlanAnualBloc, PlanAnualState>(
            builder: (context, state) {
              if (state is PlanAnualLoaded) {
                return _buildYearDropdown(state.planesAnuales);
              }
              return Container(); // Retorna un contenedor vacío si no hay datos
            },
          ),
        ],
      ),
      body: BlocBuilder<PlanAnualBloc, PlanAnualState>(
        builder: (context, state) {
          if (state is PlanAnualLoaded) {
            List<Quincena> quincenasFiltradas = state.planesAnuales
                .where((p) => p.ano == selectedYear)
                .expand((p) => p.quincenas)
                .toList();

            PlanAnualModel currentPlan = state.planesAnuales
                .firstWhere((element) => element.ano == selectedYear);

            return ListView.builder(
              itemCount: quincenasFiltradas.length,
              itemBuilder: (context, index) {
                return QuincenaItem(
                  planAnual: currentPlan,
                  quincena: quincenasFiltradas[index],
                  salario: sueldo,
                );
              },
            );
          } else if (state is PlanAnualLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlanAnualError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No se han cargado los datos.'));
        },
      ),
      drawer: const FinanzasDrawerMenu(),
    );
  }

  Widget _buildYearDropdown(List<PlanAnualModel> planesAnuales) {
    var years = planesAnuales.map((p) => p.ano).toSet().toList();
    years.sort();

    return DropdownButton<int>(
      value: selectedYear,
      onChanged: (newValue) {
        setState(() {
          selectedYear = newValue;
        });
        // Opcional: Añade lógica aquí si necesitas recargar datos basados en el año seleccionado
      },
      items: years.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      hint: const Text('Selecciona un año'),
    );
  }
}
