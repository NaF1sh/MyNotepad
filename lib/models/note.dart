import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;       
  final String? imagePath;
  final DateTime createdAt;
  final String type;          // 'text' or 'checklist'
  final List<ChecklistItem>? checklistItems;
  final int color;            // Hex color value for the text (default white)

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.createdAt,
    this.type = 'text',
    this.checklistItems,
    this.color = 0xFFFFFFFF, // Default White
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'checklistItems': checklistItems?.map((x) => x.toMap()).toList(),
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'] ?? '',
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
      type: map['type'] ?? 'text',
      checklistItems: map['checklistItems'] != null
          ? List<ChecklistItem>.from(map['checklistItems']?.map((x) => ChecklistItem.fromMap(x)))
          : [],
      color: map['color'] ?? 0xFFFFFFFF,
    );
  }

  String toJson() => json.encode(toMap());
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}

class ChecklistItem {
  String text;
  bool isDone;

  ChecklistItem({required this.text, this.isDone = false});

  Map<String, dynamic> toMap() => {'text': text, 'isDone': isDone};
  factory ChecklistItem.fromMap(Map<String, dynamic> map) =>
      ChecklistItem(text: map['text'], isDone: map['isDone']);
}
