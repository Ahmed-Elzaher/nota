class ItemModel {
  final int? id;
  final String type; // 'text', 'url', 'image'
  final String content;
  final String? title;
  final String? imageUrl;
  final String? tags; // comma separated
  final String category;
  final String createdAt;

  ItemModel({
    this.id,
    required this.type,
    required this.content,
    this.title,
    this.imageUrl,
    this.tags,
    this.category = 'أخرى',
    required this.createdAt,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      type: map['type'],
      content: map['content'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      tags: map['tags'],
      category: map['category'] ?? 'أخرى',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'content': content,
      'title': title,
      'imageUrl': imageUrl,
      'tags': tags,
      'category': category,
      'createdAt': createdAt,
    };
  }
}
