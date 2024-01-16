import 'package:intl/intl.dart';
import 'package:zen_organizer/config/domain/entities/note_item.dart';

class NotesModel extends NoteItem {
  NotesModel({
    required String id,
    required String title,
    required String content,
    required DateTime creationDate,
    List<String> tags = const [],
  }) : super(
          id: id,
          title: title,
          content: content,
          creationDate: creationDate,
          tags: tags,
        );

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
