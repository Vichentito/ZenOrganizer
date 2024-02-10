import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

class AddGastoFijoModal extends StatefulWidget {
  final GastoFijoModel? existingGasto;
  final void Function(
    String titulo,
    double montoTotal,
    List<GrupoPagos> grupoPagos,
  ) onAdd;

  const AddGastoFijoModal({Key? key, this.existingGasto, required this.onAdd})
      : super(key: key);

  @override
  AddGastoFijoModalState createState() => AddGastoFijoModalState();
}

class AddGastoFijoModalState extends State<AddGastoFijoModal> {
  late String titulo;
  late double montoTotal;
  List<GrupoPagos> grupos = [];
  bool multiplesGrupos = false;
  Map<String, DateTime> fechasSeleccionadas = {};

  final numeroDePagosController = TextEditingController();
  final montoDeCadaPagoController = TextEditingController();
  DateTime fechaDeInicio = DateTime.now();
  bool multiplesPagos = false;

  final tituloController = TextEditingController();
  final montoTotalController = TextEditingController();
  final nuevoGrupoController = TextEditingController();
  final fechaController = TextEditingController();
  final montoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingGasto != null) {
      titulo = widget.existingGasto!.titulo;
      tituloController.text = titulo;
      montoTotal = widget.existingGasto!.montoTotal;
      montoTotalController.text = montoTotal.toString();
      grupos = widget.existingGasto!.grupoPagos;
      multiplesGrupos = grupos.length > 1;
    } else {
      titulo = '';
      montoTotal = 0.0;
      // Inicializar con un grupo "Único" si no hay múltiples grupos
      grupos = multiplesGrupos ? [] : [GrupoPagos(name: "Único", pagos: [])];
    }
  }

  void agregarGrupo() {
    if (multiplesGrupos && nuevoGrupoController.text.isNotEmpty) {
      setState(() {
        grupos.add(GrupoPagos(name: nuevoGrupoController.text, pagos: []));
        nuevoGrupoController.clear();
      });
    }
  }

  void agregarPago(GrupoPagos grupo, String montoString) {
    DateTime fecha = fechasSeleccionadas[grupo.name]!;
    setState(() {
      var nuevoPago = PagoModel(
        numero: (grupo.pagos.length + 1).toString(),
        fecha: fecha,
        monto: double.tryParse(montoString) ?? 0.0,
        pagado: false,
      );
      grupo.pagos.add(nuevoPago);
    });
  }

  void agregarMultiplesPagosAlUltimoGrupo() {
    if (grupos.isEmpty) {
      // Manejar el caso en que no haya grupos
      return;
    }

    GrupoPagos ultimoGrupo = grupos.last;
    int numeroDePagos = int.tryParse(numeroDePagosController.text) ?? 0;
    double montoDeCadaPago =
        double.tryParse(montoDeCadaPagoController.text) ?? 0.0;

    DateTime fechaActual = fechaDeInicio;
    for (int i = 0; i < numeroDePagos; i++) {
      var nuevoPago = PagoModel(
        numero: (ultimoGrupo.pagos.length + 1).toString(),
        fecha: fechaActual,
        monto: montoDeCadaPago,
        pagado: false,
      );
      ultimoGrupo.pagos.add(nuevoPago);

      // Incrementa el mes y ajusta el año si es necesario
      fechaActual = DateTime(
        fechaActual.year + (fechaActual.month == 12 ? 1 : 0),
        fechaActual.month == 12 ? 1 : fechaActual.month + 1,
        fechaActual.day,
      );
    }
    // Actualizar el estado para reflejar los cambios
    setState(() {
      numeroDePagosController.clear();
      montoDeCadaPagoController.clear();
      fechaDeInicio = DateTime.now();
    });
  }

  void presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaDeInicio,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != fechaDeInicio) {
      setState(() {
        fechaDeInicio = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration:
                    const InputDecoration(labelText: 'Título Gasto Fijo'),
              ),
              TextField(
                controller: montoTotalController,
                decoration:
                    const InputDecoration(labelText: 'Deuda Total Actual'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              Row(
                children: [
                  const Expanded(child: Text('Múltiples Grupos')),
                  Checkbox(
                    value: multiplesGrupos,
                    onChanged: (bool? newValue) {
                      setState(() {
                        multiplesGrupos = newValue!;
                        if (multiplesGrupos) {
                          // Borrar grupo "Único" y esperar a que el usuario agregue nuevos grupos
                          grupos.clear();
                        } else {
                          // Agregar automáticamente un grupo "Único"
                          grupos = [GrupoPagos(name: "Único", pagos: [])];
                        }
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(child: Text('Multiples pagos iguales')),
                  Checkbox(
                    value: multiplesPagos,
                    onChanged: (bool? newValue) {
                      setState(() {
                        multiplesPagos = newValue!;
                      });
                    },
                  ),
                ],
              ),
              if (multiplesGrupos)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nuevoGrupoController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre del Nuevo Grupo'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: agregarGrupo,
                    ),
                  ],
                ), // No mostrar nada si no se usan múltiples grupos
              if (multiplesPagos)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: numeroDePagosController,
                        decoration:
                            const InputDecoration(labelText: 'Número de Pagos'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: montoDeCadaPagoController,
                        decoration: const InputDecoration(
                            labelText: 'Monto de Cada Pago'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ],
                ),
              if (multiplesPagos)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: presentDatePicker,
                        child: Text(
                            'Repite cada ${DateFormat('dd/MM/yyyy').format(fechaDeInicio)}'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: agregarMultiplesPagosAlUltimoGrupo,
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text("Grupos de Pagos"),
              ...grupos.map((grupo) => _buildGrupoPago(grupo)).toList(),
              const SizedBox(height: 25),
              const SizedBox(height: 25),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  widget.onAdd(tituloController.text,
                      double.tryParse(montoTotalController.text)!, grupos);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrupoPago(GrupoPagos grupo) {
    final montoController = TextEditingController();
    fechasSeleccionadas.putIfAbsent(grupo.name, () => DateTime.now().toLocal());

    void presentDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fechasSeleccionadas[grupo.name]!,
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          fechasSeleccionadas[grupo.name] =
              DateTime(picked.year, picked.month, picked.day);
        });
      }
    }

    return Column(
      children: [
        Text(grupo.name),
        ...grupo.pagos
            .map((pago) => Text(
                "Número: ${pago.numero} Fecha: ${DateFormat('dd/MM/yyyy').format(pago.fecha)} Monto: \$${pago.monto}"))
            .toList(),
        if (!multiplesPagos)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: presentDatePicker,
                  child: Text(
                      'Fecha: ${DateFormat('dd/MM/yyyy').format(fechasSeleccionadas[grupo.name]!)}'),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: montoController,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (montoController.text.isNotEmpty) {
                    agregarPago(grupo, montoController.text);
                  }
                },
              ),
            ],
          )
      ],
    );
  }
}
