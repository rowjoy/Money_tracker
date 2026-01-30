class NoteModel {
  final int? id;
  final String title;
  final String content;
  final bool pinned;
  final String createdAt;
  final String? updatedAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.pinned,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "pinned": pinned ? 1 : 0,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static NoteModel fromMap(Map<String, dynamic> map) => NoteModel(
        id: map["id"] as int?,
        title: (map["title"] ?? "") as String,
        content: (map["content"] ?? "") as String,
        pinned: (map["pinned"] ?? 0) == 1,
        createdAt: map["created_at"] as String,
        updatedAt: map["updated_at"] as String?,
      );
}
