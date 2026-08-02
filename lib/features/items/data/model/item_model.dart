import 'package:isar/isar.dart';

part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;
  String type; // 'text', 'url', 'image'
  String content;
  String? title;
  String? imageUrl;
  String? tags; // comma separated
  String category;
  String createdAt;

  ItemModel({
    this.id = Isar.autoIncrement,
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
      id: map['id'] ?? Isar.autoIncrement,
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
      if (id != Isar.autoIncrement) 'id': id,
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
