class ItemEntity {
  int id;
  final String type;
  final String content;
  final String? title;
  final String? imageUrl;
  final String? tags;
  final String category;
  final String createdAt;

  ItemEntity({
    required this.id,
    required this.type,
    required this.content,
    this.title,
    this.imageUrl,
    this.tags,
    this.category = 'أخرى',
    required this.createdAt,
  });
}
