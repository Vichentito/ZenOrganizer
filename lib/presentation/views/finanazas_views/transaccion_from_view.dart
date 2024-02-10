import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/providers/finanzas/gastos_fijos_providers.dart';

class TransactionFormView extends ConsumerStatefulWidget {
  const TransactionFormView({super.key});

  @override
  TransactionFormViewState createState() => TransactionFormViewState();
}

class TransactionFormViewState extends ConsumerState<TransactionFormView> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  double monto = 0.0;
  DateTime fecha = DateTime.now();
  String? selectedGastoFijoId;
  String? selectedGrupoPagosId;
  String? selectedPagoId;

  GastoFijoModel? selectedGastoFijo;
  GrupoPagos? selectedGrupoPagos;
  PagoModel? selectedPago;

  @override
  void initState() {
    super.initState();
    ref.read(gastosFijosStateProvider.notifier).loadGastos();
  }

  @override
  Widget build(BuildContext context) {
    final gastosFijosState = ref.watch(gastosFijosStateProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              gastosFijosState.gastosFijosList.when(
                data: (gastosFijos) {
                  return DropdownButtonFormField<String>(
                    value: selectedGastoFijoId,
                    hint: const Text('Selecciona un gasto fijo'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGastoFijoId = newValue;
                        selectedGastoFijo = gastosFijos.firstWhere(
                            (gasto) => gasto.id == newValue,
                            orElse: () => GastoFijoModel(
                                id: '', titulo: '', montoTotal: 0.0));
                        selectedGrupoPagosId = null;
                        selectedPagoId = null;
                        selectedGrupoPagos = null;
                        selectedPago = null;
                      });
                    },
                    items: gastosFijos
                        .map<DropdownMenuItem<String>>((GastoFijoModel gasto) {
                      return DropdownMenuItem<String>(
                        value: gasto.id,
                        child: Text(gasto.titulo),
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => Text('Error: $e'),
              ),
              if (selectedGastoFijo != null)
                DropdownButtonFormField<String>(
                  value: selectedGrupoPagosId,
                  hint: const Text('Selecciona un grupo de pagos'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGrupoPagosId = newValue;
                      selectedGrupoPagos = selectedGastoFijo?.grupoPagos
                          .firstWhere((grupo) => grupo.name == newValue,
                              orElse: () => GrupoPagos(name: ''));
                      selectedPagoId = null;
                      selectedPago = null;
                    });
                  },
                  items: selectedGastoFijo!.grupoPagos
                      .map<DropdownMenuItem<String>>((GrupoPagos grupo) {
                    return DropdownMenuItem<String>(
                      value: grupo.name,
                      child: Text(grupo.name),
                    );
                  }).toList(),
                ),
              if (selectedGrupoPagos != null)
                DropdownButtonFormField<String>(
                  value: selectedPagoId,
                  hint: const Text('Selecciona un pago'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPagoId = newValue;
                      selectedPago = selectedGrupoPagos?.pagos.firstWhere(
                          (pago) => pago.numero == newValue,
                          orElse: () => PagoModel(
                              numero: '', monto: 0.0, fecha: DateTime.now()));
                      if (selectedPago != null) {
                        nombre =
                            'Pago ${selectedPago!.numero} de ${selectedGastoFijo!.titulo} - ${selectedGrupoPagos!.name}';
                        monto = selectedPago!.monto * -1;
                        fecha = selectedPago!.fecha;
                      }
                      _formKey.currentState!.save();
                    });
                  },
                  items: selectedGrupoPagos!.pagos
                      .map<DropdownMenuItem<String>>((PagoModel pago) {
                    return DropdownMenuItem<String>(
                      value: pago.numero,
                      child: Text(
                          '${pago.numero} - ${DateFormat('dd/MM/yyyy').format(pago.fecha)}'),
                    );
                  }).toList(),
                ),
              if (selectedGastoFijo == null)
                TextFormField(
                  initialValue: nombre,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de la Transacción'),
                  validator: (value) {
                    if (selectedGastoFijo == null &&
                        (value == null || value.isEmpty)) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombre = value!;
                  },
                ),
              if (selectedGastoFijo == null)
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: fecha,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != fecha) {
                      setState(() {
                        fecha = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(fecha)}',
                  ),
                ),
              if (selectedGastoFijo == null)
                TextFormField(
                  initialValue: monto.toString(),
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (selectedPago == null &&
                        (value == null || value.isEmpty)) {
                      return 'Por favor ingrese un monto';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    monto = double.parse(value!);
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.of(context).pop(Transaccion(
                      nombre: nombre,
                      fecha: fecha,
                      monto: monto,
                    ));
                  }
                },
                child: const Text('Agregar Transacción'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
