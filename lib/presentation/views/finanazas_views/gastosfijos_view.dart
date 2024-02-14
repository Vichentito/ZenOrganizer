import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';
import 'package:zen_organizer/presentation/providers/finanzas/gastos_fijos_providers.dart';
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
    ref.read(gastosFijosStateProvider.notifier).loadGastos();
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
          ref
              .read(gastosFijosStateProvider.notifier)
              .addGastoInFirestore(newGastoFijo);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gastosFijosState = ref.watch(gastosFijosStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Fijos'),
      ),
      body: gastosFijosState.gastosFijosList.when(
          data: (gastosList) {
            return ListView.builder(
              itemCount: gastosList.length,
              itemBuilder: ((context, index) {
                final gasto = gastosList[index];
                return GastoFijoItem(
                  gastoFijo: gasto,
                );
              }),
            );
          },
          error: (err, stack) => Center(
                child: Text('Error: $err'),
              ),
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      drawer: const FinanzasDrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGastoModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
