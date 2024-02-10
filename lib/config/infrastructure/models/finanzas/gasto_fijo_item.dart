import 'package:intl/intl.dart';

class GastoFijoModel {
  final String id;
  final String titulo;
  final double montoTotal;
  final List<GrupoPagos> grupoPagos;
  final String estado;
  final double total;

  GastoFijoModel({
    required this.id,
    required this.titulo,
    required this.montoTotal,
    this.grupoPagos = const [],
    this.estado = 'activo',
    this.total = 0.0,
  });

  double get totalPagado {
    return grupoPagos.fold(
        0.0, (previousValue, element) => previousValue + element.total);
  }

  factory GastoFijoModel.fromJson(Map<String, dynamic> json) {
    return GastoFijoModel(
      id: json['id'],
      titulo: json['titulo'],
      montoTotal: double.parse(json['montoTotal'].toString()),
      grupoPagos: (json['grupoPagos'] as List<dynamic>)
          .map((grupo) => GrupoPagos.fromJson(grupo))
          .toList(),
      estado: json['estado'] ?? 'activo',
      total: double.parse(json['total'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'montoTotal': montoTotal,
      'grupoPagos': grupoPagos.map((grupo) => grupo.toJson()).toList(),
      'estado': estado,
      'total': total,
    };
  }

  GastoFijoModel copyWith({
    String? id,
    String? titulo,
    double? montoTotal,
    List<GrupoPagos>? grupoPagos,
    String? estado,
    double? total,
  }) {
    return GastoFijoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      montoTotal: montoTotal ?? this.montoTotal,
      grupoPagos: grupoPagos ?? this.grupoPagos,
      estado: estado ?? this.estado,
      total: total ?? this.total,
    );
  }
}

class GrupoPagos {
  final String name;
  final List<PagoModel> pagos;

  GrupoPagos({
    required this.name,
    this.pagos = const [],
  });

  double get total {
    return pagos.fold(
        0.0, (previousValue, element) => previousValue + element.monto);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pagos': pagos.map((pago) => pago.toJson()).toList(),
    };
  }

  factory GrupoPagos.fromJson(Map<String, dynamic> json) {
    return GrupoPagos(
      name: json['name'],
      pagos: (json['pagos'] as List<dynamic>)
          .map((pagoJson) => PagoModel.fromJson(pagoJson))
          .toList(),
    );
  }

  GrupoPagos copyWith({
    String? name,
    List<PagoModel>? pagos,
  }) {
    return GrupoPagos(
      name: name ?? this.name,
      pagos: pagos ?? this.pagos,
    );
  }
}

class PagoModel {
  String numero;
  double monto;
  DateTime fecha;
  bool pagado;

  PagoModel({
    required this.numero,
    required this.monto,
    required this.fecha,
    this.pagado = false,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      numero: json['numero'],
      monto: double.parse(json['monto'].toString()),
      fecha: DateTime.parse(json['fecha']),
      pagado: json['pagado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'monto': monto,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha),
      'pagado': pagado,
    };
  }

  PagoModel copyWith({
    String? numero,
    double? monto,
    DateTime? fecha,
    bool? pagado,
  }) {
    return PagoModel(
      numero: numero ?? this.numero,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      pagado: pagado ?? this.pagado,
    );
  }
}
