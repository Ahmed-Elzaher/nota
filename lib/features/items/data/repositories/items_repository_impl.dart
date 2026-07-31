import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/data_sources/local_data_source.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsLocalDataSource localDataSource;

  ItemsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<String, List<ItemModel>>> getItems() async {
    try {
      final items = await localDataSource.getItems();
      return Right(items);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ItemModel>>> searchItems(String query) async {
    try {
      final items = await localDataSource.searchItems(query);
      return Right(items);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> addItem(ItemModel item) async {
    try {
      final id = await localDataSource.addItem(item);
      return Right(id);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateItem(ItemModel item) async {
    try {
      await localDataSource.updateItem(item);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> deleteItem(int id) async {
    try {
      final result = await localDataSource.deleteItem(id);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
