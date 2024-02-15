import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';
import 'package:zen_organizer/presentation/blocs/gastos_fijos_bloc/gastos_fijos_bloc.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/add_gastofijo_modal.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/gastofijo_item.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart';

class GastosFijosView extends ConsumerStatefulWidget {
  const GastosFijosView({super.key});

  @override
  GastosFijosViewState createState() => GastosFijosViewState();
}

class GastosFijosViewState extends ConsumerState<GastosFijosView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GastosFijosBloc>(context, listen: false)
        .add(LoadGastosFijos());
  }

  void _showAddGastoModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddGastoFijoModal(onAdd: (titulo, montoTotal, grupoPagos) {
          final newGastoFijo = GastoFijoModel(
            id: '',
            titulo: titulo,
            montoTotal: montoTotal,
            grupoPagos: grupoPagos,
          );
          BlocProvider.of<GastosFijosBloc>(context, listen: false)
              .add(AddGastoFijo(newGastoFijo));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Fijos'),
      ),
      body: BlocBuilder<GastosFijosBloc, GastosFijosState>(
        builder: (context, state) {
          if (state is GastosFijosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GastosFijosContent) {
            return ListView.builder(
              itemCount: state.gastosFijos.length,
              itemBuilder: (context, index) {
                final gasto = state.gastosFijos[index];
                return GastoFijoItem(gastoFijo: gasto);
              },
            );
          } else if (state is GastosFijosError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No se han cargado los datos.'));
        },
      ),
      drawer: const FinanzasDrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGastoModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
