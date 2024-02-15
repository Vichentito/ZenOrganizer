import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';
import 'package:zen_organizer/presentation/blocs/gastos_fijos_bloc/gastos_fijos_bloc.dart';

class TransactionFormView extends StatelessWidget {
  TransactionFormView({Key? key}) : super(key: key);

  final GastoFijoDataSource dataSource = GastoFijodbDatasource();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GastosFijosBloc(dataSource),
      child: const TransactionFormViewBody(),
    );
  }
}

class TransactionFormViewBody extends StatefulWidget {
  const TransactionFormViewBody({Key? key}) : super(key: key);

  @override
  TransactionFormViewState createState() => TransactionFormViewState();
}

class TransactionFormViewState extends State<TransactionFormViewBody> {
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
    context.read<GastosFijosBloc>().add(LoadGastosFijos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocBuilder<GastosFijosBloc, GastosFijosState>(
                  builder: (context, state) {
                    if (state is GastosFijosLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is GastosFijosContent) {
                      return DropdownButtonFormField<String>(
                        value: selectedGastoFijoId,
                        hint: const Text('Selecciona un gasto fijo'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGastoFijoId = newValue;
                            selectedGastoFijo = state.gastosFijos.firstWhere(
                              (gasto) => gasto.id == newValue,
                            );
                            // Restablecer las selecciones de grupo de pagos y pagos si es necesario
                            selectedGrupoPagosId = null;
                            selectedPagoId = null;
                          });
                        },
                        items: state.gastosFijos.map<DropdownMenuItem<String>>(
                            (GastoFijoModel gasto) {
                          return DropdownMenuItem<String>(
                            value: gasto.id,
                            child: Text(gasto.titulo),
                          );
                        }).toList(),
                      );
                    } else if (state is GastosFijosError) {
                      return Text('Error: ${state.message}');
                    }
                    return const Text('Estado no esperado.');
                  },
                ),
                // A partir de aquí, puedes agregar los demás DropdownButtonFormField
                // para grupo de pagos y pago específico basándote en selectedGastoFijo
                // y manejar sus cambios de estado de manera similar usando setState.

                TextFormField(
                  initialValue: nombre,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de la Transacción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombre = value!;
                  },
                ),
                // Añadir más campos y lógica aquí según sea necesario

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Aquí puedes manejar la creación de la Transacción
                      // con los datos recogidos del formulario
                      Navigator.pop(
                          context,
                          Transaccion(
                            nombre: nombre,
                            fecha: fecha,
                            monto: monto,
                          ));
                    }
                  },
                  child: const Text('Guardar Transacción'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
