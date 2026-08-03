import 'package:isar/isar.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';

part 'item_model.g.dart';

@collection
class ItemModel implements ItemEntity {
  @override
  Id id = Isar.autoIncrement;
  @override
  String type;
  @override
  String content;
  @override
  String? title;
  @override
  String? imageUrl;
  @override
  String? tags;
  @override
  String category;
  @override
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
