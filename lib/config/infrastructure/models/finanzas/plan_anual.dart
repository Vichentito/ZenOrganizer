import 'package:intl/intl.dart';

class PlanAnualModel {
  final String id;
  final int ano;
  List<Quincena> quincenas;

  PlanAnualModel({
    required this.id,
    required this.ano,
    this.quincenas = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'ano': ano,
      'quincenas': quincenas.map((e) => e.toJson()).toList(),
    };
  }

  factory PlanAnualModel.fromJson(Map<String, dynamic> json) {
    return PlanAnualModel(
      id: json['id'],
      ano: json['ano'],
      quincenas:
          (json['quincenas'] as List).map((i) => Quincena.fromJson(i)).toList(),
    );
  }

  PlanAnualModel copyWith({
    String? id,
    int? ano,
    List<Quincena>? quincenas,
  }) {
    return PlanAnualModel(
      id: id ?? this.id,
      ano: ano ?? this.ano,
      quincenas: quincenas ?? this.quincenas,
    );
  }
}

class Quincena {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  List<Transaccion> transacciones;
  final double total;

  Quincena({
    required this.fechaInicio,
    required this.fechaFin,
    this.transacciones = const [],
    this.total = 0.0,
  });

  double get totalQuincena {
    return transacciones.fold(
        0.0, (previousValue, transaccion) => previousValue + transaccion.monto);
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaInicio': DateFormat('yyyy-MM-dd').format(fechaInicio),
      'fechaFin': DateFormat('yyyy-MM-dd').format(fechaFin),
      'transacciones': transacciones.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }

  factory Quincena.fromJson(Map<String, dynamic> json) {
    return Quincena(
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
      transacciones: (json['transacciones'] as List)
          .map((i) => Transaccion.fromJson(i))
          .toList(),
      total: double.parse(json['total'].toString()),
    );
  }

  Quincena copyWith({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    List<Transaccion>? transacciones,
    double? total,
  }) {
    return Quincena(
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      transacciones: transacciones ?? this.transacciones,
      total: total ?? this.total,
    );
  }
}

class Transaccion {
  final String nombre;
  final DateTime fecha;
  final double monto;

  Transaccion({
    required this.nombre,
    required this.fecha,
    required this.monto,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha),
      'monto': monto,
    };
  }

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      nombre: json['nombre'],
      fecha: DateTime.parse(json['fecha']),
      monto: double.parse(json['monto'].toString()),
    );
  }

  Transaccion copyWith({
    String? nombre,
    DateTime? fecha,
    double? monto,
  }) {
    return Transaccion(
      nombre: nombre ?? this.nombre,
      fecha: fecha ?? this.fecha,
      monto: monto ?? this.monto,
    );
  }
}
