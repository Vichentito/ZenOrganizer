import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/plan_anual.dart';

class QuincenaItem extends StatelessWidget {
  final Quincena quincena;
  final PlanAnualModel planAnual;
  final double salario; // Este valor puede venir de ConfigProvider
  final NumberFormat formatter = NumberFormat('#,##0.00', 'es_ES');

  QuincenaItem(
      {Key? key,
      required this.quincena,
      required this.salario,
      required this.planAnual})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        //print(quincena.fechaInicio);
        context.go('/finanzas/quincenaDetails/', extra: {
          'planAnualId': planAnual.id,
          'quincenaInicio': quincena.fechaInicio.toIso8601String(),
          'quincenaFin': quincena.fechaFin.toIso8601String(),
        });
      },
      child: Card(
        child: ExpansionTile(
          title: Text(
            'Quincena del ${DateFormat('dd/MM/yyyy').format(quincena.fechaInicio)} - ${DateFormat('dd/MM/yyyy').format(quincena.fechaFin)}',
          ),
          children: <Widget>[
            _buildDetailTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Concepto')),
        DataColumn(label: Text('Fecha')),
        DataColumn(label: Text('Monto')),
      ],
      rows: _buildTableRows(),
    );
  }

  List<DataRow> _buildTableRows() {
    List<DataRow> rows = [];

    // Añadir fila para el salario
    rows.add(
      DataRow(
        cells: <DataCell>[
          const DataCell(Text('Salario')),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(
              quincena.fechaInicio))), // Fecha de inicio como referencia
          DataCell(Text('\$${formatter.format(salario)}')),
        ],
      ),
    );

    // Añadir filas para cada transacción
    for (var transaccion in quincena.transacciones) {
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(transaccion.nombre)),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(transaccion.fecha))),
            DataCell(Text('\$${formatter.format(transaccion.monto)}')),
          ],
        ),
      );
    }

    double totalConSalario = salario + quincena.totalQuincena;
    // Añadir fila para el total
    rows.add(
      DataRow(
        cells: <DataCell>[
          const DataCell(Text('Total')),
          const DataCell(Text('')),
          DataCell(Text('\$${formatter.format(totalConSalario)}')),
        ],
      ),
    );

    return rows;
  }
}
