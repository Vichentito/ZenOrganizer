import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/blocs/finanzas_config_bloc/finanzas_config_bloc.dart';
import 'package:zen_organizer/presentation/blocs/plan_anual_bloc/plan_anual_bloc.dart';
import 'package:zen_organizer/presentation/providers/finanzas/plan_anual_providers.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/transaccion_from_view.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart'; // Asegúrate de importar correctamente tu modelo Quincena

class QuincenaDetailView extends ConsumerStatefulWidget {
  final String planAnualId;
  final DateTime quincenaInicio;
  final DateTime quincenaFin;

  const QuincenaDetailView(
      {super.key,
      required this.planAnualId,
      required this.quincenaInicio,
      required this.quincenaFin});

  @override
  QuincenaDetailViewState createState() => QuincenaDetailViewState();
}

class QuincenaDetailViewState extends ConsumerState<QuincenaDetailView> {
  final NumberFormat formatter = NumberFormat('#,##0.00', 'es_ES');
  double sueldo = 0.0;
  int? editingTransactionIndex;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PlanAnualBloc>().add(LoadPlanesAnuales());
    context.read<FinanzasConfigBloc>().add(LoadConfig());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Quincena'),
      ),
      body: BlocBuilder<PlanAnualBloc, PlanAnualState>(
        builder: (context, state) {
          if (state is PlanAnualLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlanAnualLoaded) {
            final PlanAnualModel specificPlan = state.planesAnuales
                .firstWhere((plan) => plan.id == widget.planAnualId);
            final Quincena specificQuincena = specificPlan.quincenas.firstWhere(
                (quincena) =>
                    quincena.fechaInicio == widget.quincenaInicio &&
                    quincena.fechaFin == widget.quincenaFin);
            return BlocBuilder<FinanzasConfigBloc, FinanzasConfigState>(
              builder: (context, configState) {
                double sueldo = 0.0;
                if (configState is FinanzasConfigLoaded) {
                  sueldo = configState.config
                      .sueldo; // Asumiendo que el estado tiene una propiedad `sueldo`
                }

                // A partir de aquí, tu lógica existente para construir la UI con `specificPlan` y `specificQuincena`
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildCustomTable(specificQuincena, sueldo),
                  ),
                );
              },
            );
          }

          // Manejo de estado de error
          if (state is PlanAnualError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // Estado predeterminado si no se reconoce el estado actual
          return const Center(child: Text('Estado no reconocido'));
        },
      ),
      drawer: const FinanzasDrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTransaction(specificPlan, specificQuincena),
        tooltip: 'Agregar Transacción',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCustomTable(Quincena quincena, double sueldo) {
    List<Widget> rows = [
      // Fila de encabezado
      const Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 12.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Concepto',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Fecha',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Monto',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      // Fila para el salario
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Expanded(
              flex: 3,
              child: Text(
                'Salario',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('dd/MM/yyyy').format(quincena.fechaInicio),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${formatter.format(sueldo)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ];

    // Filas para cada transacción
    for (int i = 0; i < quincena.transacciones.length; i++) {
      final transaccion = quincena.transacciones[i];
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(transaccion.nombre,
                    style: const TextStyle(fontSize: 16)),
              ),
              Expanded(
                flex: 2,
                child: Text(DateFormat('dd/MM/yyyy').format(transaccion.fecha),
                    style: const TextStyle(fontSize: 16)),
              ),
              Expanded(
                flex: 2,
                child: i == editingTransactionIndex
                    ? TextField(
                        controller: editingController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          _updateTransactionAmount(i, double.parse(value));
                        },
                      )
                    : GestureDetector(
                        onLongPress: () {
                          setState(() {
                            editingTransactionIndex = i;
                            editingController.text =
                                transaccion.monto.toString();
                          });
                        },
                        child: Text('\$${formatter.format(transaccion.monto)}',
                            style: const TextStyle(fontSize: 16)),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    rows.add(const Divider(
      color: Colors.black,
    ));

    double totalConSalario = sueldo +
        quincena.transacciones.fold(0.0, (prev, trans) => prev + trans.monto);
    // Fila para el total
    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            const Expanded(
              flex: 3,
              child: Text(
                'Total',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text('', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${formatter.format(totalConSalario)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(children: rows);
  }

  void _addNewTransaction(PlanAnualModel plan, Quincena quincena) async {
    final Transaccion? newTransaccion = await showModalBottomSheet<Transaccion>(
      context: context,
      builder: (BuildContext context) {
        return const TransactionFormView();
      },
    );

    if (newTransaccion != null) {
      PlanAnualModel updatedPlan = plan.copyWith();
      int quincenaIndex = updatedPlan.quincenas.indexOf(quincena);
      if (quincenaIndex != -1) {
        Quincena updatedQuincena =
            updatedPlan.quincenas[quincenaIndex].copyWith(
          transacciones: [
            ...updatedPlan.quincenas[quincenaIndex].transacciones,
            newTransaccion,
          ],
        );
        updatedPlan.quincenas[quincenaIndex] = updatedQuincena;

        try {
          await ref
              .read(planAnualStateProvider.notifier)
              .updatePlanInFirestore(widget.planAnualId, updatedPlan, plan);
          // Forzar la recarga de los planes después de la actualización
          await ref.read(planAnualStateProvider.notifier).loadPlanes();
        } catch (e) {
          // Manejar errores, por ejemplo, mostrando un mensaje al usuario
        }
      }
    }
  }

  void _updateTransactionAmount(int index, double newAmount) async {
    final planAnualState = ref.read(planAnualStateProvider);
    planAnualState.planAnualList.whenData((plans) async {
      final specificPlan = plans.firstWhere(
        (plan) => plan.id == widget.planAnualId,
        orElse: () => PlanAnualModel(id: '', ano: DateTime.now().year),
      );

      int quincenaIndex = specificPlan.quincenas.indexWhere(
        (quincena) =>
            quincena.fechaInicio == widget.quincenaInicio &&
            quincena.fechaFin == widget.quincenaFin,
      );

      if (quincenaIndex != -1) {
        Quincena updatedQuincena =
            specificPlan.quincenas[quincenaIndex].copyWith(
          transacciones:
              List.from(specificPlan.quincenas[quincenaIndex].transacciones),
        );
        updatedQuincena.transacciones[index] =
            updatedQuincena.transacciones[index].copyWith(monto: newAmount);

        PlanAnualModel updatedPlan = specificPlan.copyWith();
        updatedPlan.quincenas[quincenaIndex] = updatedQuincena;

        try {
          // Actualizar el plan anual en Firestore
          await ref.read(planAnualStateProvider.notifier).updatePlanInFirestore(
              widget.planAnualId, updatedPlan, specificPlan);
          // Forzar la recarga de los planes después de la actualización
          await ref.read(planAnualStateProvider.notifier).loadPlanes();
          setState(() {
            editingTransactionIndex = null;
          });
        } catch (e) {
          // Manejar errores, por ejemplo, mostrando un mensaje al usuario
        }
      }
    });
  }
}
