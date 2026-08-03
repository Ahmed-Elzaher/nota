import 'package:isar/isar.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';

part 'mind_map_model.g.dart';

@embedded
class MapNodeModel {
  String? id;
  String? text;
  double? x;
  double? y;
  String? color;

  MapNodeModel({
    this.id,
    this.text,
    this.x,
    this.y,
    this.color,
  });

  factory MapNodeModel.fromEntity(MapNode entity) {
    return MapNodeModel(
      id: entity.id,
      text: entity.text,
      x: entity.x,
      y: entity.y,
      color: entity.color,
    );
  }

  MapNode toEntity() {
    return MapNode(
      id: id ?? '',
      text: text ?? '',
      x: x ?? 0.0,
      y: y ?? 0.0,
      color: color,
    );
  }
}

@embedded
class MapEdgeModel {
  String fromNodeId = '';
  String toNodeId = '';

  MapEdgeModel();

  factory MapEdgeModel.fromEntity(MapEdge entity) {
    return MapEdgeModel()
      ..fromNodeId = entity.fromNodeId
      ..toNodeId = entity.toNodeId;
  }

  MapEdge toEntity() {
    return MapEdge(
      fromNodeId: fromNodeId,
      toNodeId: toNodeId,
    );
  }
}

@collection
class MindMapModel {
  Id id = Isar.autoIncrement;
  String title;
  String createdAt;
  String updatedAt;

  List<MapNodeModel> nodeModels;
  List<MapEdgeModel> edgeModels;

  MindMapModel({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.nodeModels = const [],
    this.edgeModels = const [],
  });

  @ignore
  List<MapNode> get nodes => nodeModels.map((e) => e.toEntity()).toList();

  @ignore
  List<MapEdge> get edges => edgeModels.map((e) => e.toEntity()).toList();

  factory MindMapModel.fromEntity(MindMapEntity entity) {
    return MindMapModel(
      id: entity.id == 0 ? Isar.autoIncrement : entity.id,
      title: entity.title,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      nodeModels: entity.nodes.map((e) => MapNodeModel.fromEntity(e)).toList(),
      edgeModels: entity.edges.map((e) => MapEdgeModel.fromEntity(e)).toList(),
    );
  }

  MindMapEntity toEntity() {
    return MindMapEntity(
      id: id,
      title: title,
      createdAt: createdAt,
      updatedAt: updatedAt,
      nodes: nodes,
      edges: edges,
    );
  }
}
