import 'package:intl/intl.dart';

class NotesModel {
  final String id;
  final String title;
  final String content;
  final DateTime creationDate;
  final List<String> tags;

  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    this.tags = const [],
  });
  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      creationDate: DateTime.parse(json['creationDate']),
      tags: json['tags'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'creationDate': DateFormat('yyyy-MM-dd').format(creationDate),
      'tags': tags,
    };
  }

  NotesModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? creationDate,
    List<String>? tags,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      tags: tags ?? this.tags,
    );
  }
}
