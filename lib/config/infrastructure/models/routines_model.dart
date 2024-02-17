import 'package:intl/intl.dart';

class RoutineEvent {
  final String id;
  final String description;
  final DateTime time;
  bool isCompleted;

  RoutineEvent({
    required this.id,
    required this.description,
    required this.time,
    this.isCompleted = false,
  });

  factory RoutineEvent.fromJson(Map<String, dynamic> json) {
    return RoutineEvent(
      id: json['id'],
      description: json['description'],
      time: DateTime.parse(json['time']).toLocal(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'time': DateFormat('yyyy-MM-dd HH:mm').format(time),
      'isCompleted': isCompleted,
    };
  }

  RoutineEvent copyWith({
    String? id,
    String? description,
    DateTime? time,
    bool? isCompleted,
  }) {
    return RoutineEvent(
        id: id ?? this.id,
        description: description ?? this.description,
        time: time ?? this.time,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}

// Your daily routine
class DailyRoutine {
  final String id;
  final DateTime date;
  final String name; // Optional if you want to name days
  final List<RoutineEvent> events;

  DailyRoutine({
    required this.id,
    required this.date,
    this.name = '',
    required this.events,
  });

  factory DailyRoutine.fromJson(Map<String, dynamic> json) {
    return DailyRoutine(
      id: json['id'],
      date: DateTime.parse(json['date']).toLocal(),
      name: json['name'],
      events: (json['events'] as List)
          .map((event) => RoutineEvent.fromJson(event))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'name': name,
      'events': events.map((event) => event.toJson()).toList(),
    };
  }

  DailyRoutine copyWith({
    String? id,
    DateTime? date,
    String? name,
    List<RoutineEvent>? events,
  }) {
    return DailyRoutine(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      events: events ?? this.events,
    );
  }
}
