import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/gasto_fijo_item.dart';

class GastoFijoItem extends StatelessWidget {
  final GastoFijoModel gastoFijo;
  final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');

  GastoFijoItem({Key? key, required this.gastoFijo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double diferencia = gastoFijo.montoTotal - gastoFijo.totalPagado;

    return Card(
      child: ExpansionTile(
        title: Text(gastoFijo.titulo),
        subtitle: Text('Total: \$${formatter.format(gastoFijo.montoTotal)}'),
        children: [
          ..._buildPagosYDiferencia(gastoFijo, diferencia),
        ],
      ),
    );
  }

  List<Widget> _buildPagosYDiferencia(GastoFijoModel gasto, double diferencia) {
    List<Widget> widgets = [];
    widgets.add(
      ListTile(
        title: const Text('Total a pagar'),
        subtitle: Text('\$${formatter.format(gasto.totalPagado)}'),
      ),
    );

    widgets.add(
      Card(
        color: diferencia >= 0 ? Colors.green[100] : Colors.red[100],
        child: ListTile(
          title: const Text('Diferencia'),
          subtitle: Text('\$${formatter.format(diferencia)}'),
        ),
      ),
    );

    if (gasto.grupoPagos.length == 1) {
      widgets.addAll(_buildPagosDirectos(gasto.grupoPagos.first));
    } else {
      widgets.addAll(gasto.grupoPagos
          .map((grupo) => _buildGrupoPagosDetalle(grupo))
          .toList());
    }

    return widgets;
  }

  List<Widget> _buildPagosDirectos(GrupoPagos grupo) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          children: grupo.pagos.map((pago) => _buildPagoDetalle(pago)).toList(),
        ),
      ),
    ];
  }

  Widget _buildGrupoPagosDetalle(GrupoPagos grupo) {
    return Column(
      children: [
        ListTile(
          title: Text(grupo.name),
          subtitle: Text(
              'Total a pagar del grupo: \$${formatter.format(grupo.total)}'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            children:
                grupo.pagos.map((pago) => _buildPagoDetalle(pago)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPagoDetalle(PagoModel pago) {
    return ListTile(
      title: Text(
          'Pago ${pago.numero} ${DateFormat('dd/MM/yyyy').format(pago.fecha)}'),
      subtitle: Text('Monto: \$${formatter.format(pago.monto)}'),
      trailing:
          Icon(pago.pagado ? Icons.check_circle : Icons.check_circle_outline),
    );
  }
}
