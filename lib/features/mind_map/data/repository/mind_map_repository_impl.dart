import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/mind_map/data/data_source/mind_map_local_data_source.dart';
import 'package:nota/features/mind_map/data/model/mind_map_model.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';
import 'package:nota/features/mind_map/domain/repository/mind_map_repository.dart';

class MindMapRepositoryImpl implements MindMapRepository {
  final MindMapLocalDataSource localDataSource;

  MindMapRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<MindMapEntity>>> getMindMaps() async {
    try {
      final models = await localDataSource.getMindMaps();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> saveMindMap(MindMapEntity mindMap) async {
    try {
      final model = MindMapModel.fromEntity(mindMap);
      final id = await localDataSource.saveMindMap(model);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMindMap(int id) async {
    try {
      final result = await localDataSource.deleteMindMap(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
