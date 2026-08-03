class MapNode {
  final String id;
  final String text;
  final double x;
  final double y;
  final String? color; // added color

  MapNode({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    this.color,
  });

  MapNode copyWith({
    String? id,
    String? text,
    double? x,
    double? y,
    String? color,
  }) {
    return MapNode(
      id: id ?? this.id,
      text: text ?? this.text,
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
    );
  }
}

class MapEdge {
  final String fromNodeId;
  final String toNodeId;

  MapEdge({
    required this.fromNodeId,
    required this.toNodeId,
  });
}

class MindMapEntity {
  final int id;
  final String title;
  final List<MapNode> nodes;
  final List<MapEdge> edges;
  final String createdAt;
  final String updatedAt;

  MindMapEntity({
    required this.id,
    required this.title,
    required this.nodes,
    required this.edges,
    required this.createdAt,
    required this.updatedAt,
  });

  MindMapEntity copyWith({
    int? id,
    String? title,
    List<MapNode>? nodes,
    List<MapEdge>? edges,
    String? createdAt,
    String? updatedAt,
  }) {
    return MindMapEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
