import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/providers/finanzas/config_provider.dart';
import 'package:zen_organizer/presentation/providers/finanzas/plan_anual_providers.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/quincena_item.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart';

class QuincenasView extends ConsumerStatefulWidget {
  const QuincenasView({super.key});

  @override
  QuincenasViewState createState() => QuincenasViewState();
}

class QuincenasViewState extends ConsumerState<QuincenasView> {
  double sueldo = 0.0;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    ref.read(planAnualStateProvider.notifier).loadPlanes();
    ref.read(configStateProvider.notifier).loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    final planAnualState = ref.watch(planAnualStateProvider);
    final configAsyncValue = ref.watch(configStateProvider).config;

    configAsyncValue.whenData((data) {
      sueldo = data.sueldo;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quincenas'),
        actions: <Widget>[
          _buildYearDropdown(planAnualState.planAnualList.value ?? []),
        ],
      ),
      body: planAnualState.planAnualList.when(
        data: (listaPlanesAnuales) {
          PlanAnualModel currentPlan = listaPlanesAnuales
              .firstWhere((element) => element.ano == selectedYear);
          List<Quincena> quincenasFiltradas = selectedYear == null
              ? listaPlanesAnuales.expand((p) => p.quincenas).toList()
              : listaPlanesAnuales
                  .where((p) => p.ano == selectedYear)
                  .expand((p) => p.quincenas)
                  .toList();

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
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
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
