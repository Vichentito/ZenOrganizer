import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/blocs/finanzas_config_bloc/finanzas_config_bloc.dart';
import 'package:zen_organizer/presentation/blocs/plan_anual_bloc/plan_anual_bloc.dart';
import 'package:zen_organizer/presentation/views/finanazas_views/transaccion_from_view.dart';

class QuincenaDetailView extends StatefulWidget {
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

class QuincenaDetailViewState extends State<QuincenaDetailView> {
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
              final Quincena specificQuincena = specificPlan.quincenas
                  .firstWhere((quincena) =>
                      quincena.fechaInicio == widget.quincenaInicio &&
                      quincena.fechaFin == widget.quincenaFin);
              return BlocBuilder<FinanzasConfigBloc, FinanzasConfigState>(
                builder: (context, configState) {
                  double sueldo = 0.0;
                  if (configState is FinanzasConfigLoaded) {
                    sueldo = configState.config
                        .sueldo; // Asumiendo que el estado tiene una propiedad `sueldo`
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildCustomTable(specificQuincena, sueldo),
                    ),
                  );
                },
              );
            }
            if (state is PlanAnualError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Estado no reconocido'));
          },
        ),
        //drawer: const FinanzasDrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewTransaction(context),
          tooltip: 'Agregar Transacción',
          child: const Icon(Icons.add),
        ));
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
        padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
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

    // Añadir un espacio en blanco al final para evitar el botón flotante
    rows.add(const SizedBox(height: 80.0));

    return Column(children: rows);
  }

  void _addNewTransaction(BuildContext context) async {
    final Transaccion? newTransaccion = await showModalBottomSheet<Transaccion>(
      context: context,
      builder: (BuildContext context) {
        return TransactionFormView();
      },
    );
    if (!mounted) return;
    if (newTransaccion != null) {
      context.read<PlanAnualBloc>().add(
            AddTransaccion(
              planAnualId: widget.planAnualId,
              quincenaInicio: widget.quincenaInicio,
              quincenaFin: widget.quincenaFin,
              newTransaccion: newTransaccion,
            ),
          );
    }
  }

  void _updateTransactionAmount(int index, double newAmount) {
    context.read<PlanAnualBloc>().add(
          UpdateTransaccionAmount(
            planAnualId: widget.planAnualId,
            quincenaInicio: widget.quincenaInicio,
            quincenaFin: widget.quincenaFin,
            transaccionIndex: index,
            newAmount: newAmount,
          ),
        );
    setState(() {
      editingTransactionIndex = null;
    });
  }
}
