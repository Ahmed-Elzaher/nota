import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/data/data_source/local_data_source.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsLocalDataSource localDataSource;

  ItemsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems() async {
    try {
      final items = await localDataSource.getItems();
      return Right(items);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> searchItems(String query) async {
    try {
      final items = await localDataSource.searchItems(query);
      return Right(items);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addItem(ItemEntity item) async {
    try {
      // Cast ItemEntity to ItemModel if needed, or pass it if localDataSource expects ItemModel
      // localDataSource expects ItemModel, so we cast or map
      final itemModel = item is ItemModel ? item : ItemModel(
        id: item.id == 0 ? Isar.autoIncrement : item.id,
        type: item.type,
        content: item.content,
        title: item.title,
        imageUrl: item.imageUrl,
        tags: item.tags,
        category: item.category,
        createdAt: item.createdAt,
      );
      final id = await localDataSource.addItem(itemModel);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ItemEntity item) async {
    try {
      final itemModel = item is ItemModel ? item : ItemModel(
        id: item.id,
        type: item.type,
        content: item.content,
        title: item.title,
        imageUrl: item.imageUrl,
        tags: item.tags,
        category: item.category,
        createdAt: item.createdAt,
      );
      await localDataSource.updateItem(itemModel);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteItem(int id) async {
    try {
      final result = await localDataSource.deleteItem(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
