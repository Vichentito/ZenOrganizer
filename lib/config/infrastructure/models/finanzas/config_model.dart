import 'package:intl/intl.dart';

class ConfigModel {
  final String id;
  final double sueldo;

  ConfigModel({required this.id, required this.sueldo});

  Map<String, dynamic> toJson() {
    return {
      'sueldo': sueldo,
    };
  }

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      id: json['id'],
      sueldo: json['sueldo'],
    );
  }

  ConfigModel copyWith({
    String? id,
    double? sueldo,
  }) {
    return ConfigModel(
      id: id ?? this.id,
      sueldo: sueldo ?? this.sueldo,
    );
  }
}

class AguinaldoModel {
  final String id;
  final double monto;
  final DateTime? fecha;
  final String estado;

  AguinaldoModel({
    required this.id,
    required this.monto,
    DateTime? fecha,
    this.estado = 'no pagado',
  }) : fecha = fecha ?? DateTime(DateTime.now().year, 12, 20);

  Map<String, dynamic> toJson() {
    return {
      'monto': monto,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha!),
      'estado': estado,
    };
  }

  factory AguinaldoModel.fromJson(Map<String, dynamic> json) {
    return AguinaldoModel(
      id: json['id'],
      monto: json['monto'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }

  AguinaldoModel copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    String? estado,
  }) {
    return AguinaldoModel(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
    );
  }
}
