import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';

sealed class MindMapsState {}

class MindMapsInitial extends MindMapsState {}

class MindMapsLoading extends MindMapsState {}

class MindMapsLoaded extends MindMapsState {
  final List<MindMapEntity> mindMaps;
  MindMapsLoaded(this.mindMaps);
}

class MindMapsError extends MindMapsState {
  final Failure failure;
  MindMapsError(this.failure);
}
