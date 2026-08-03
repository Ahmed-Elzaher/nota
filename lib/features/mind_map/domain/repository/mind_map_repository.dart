import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';

abstract class MindMapRepository {
  Future<Either<Failure, List<MindMapEntity>>> getMindMaps();
  Future<Either<Failure, int>> saveMindMap(MindMapEntity mindMap);
  Future<Either<Failure, bool>> deleteMindMap(int id);
}
