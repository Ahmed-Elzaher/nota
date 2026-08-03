import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';

abstract class ItemsRepository {
  Future<Either<Failure, List<ItemEntity>>> getItems();
  Future<Either<Failure, List<ItemEntity>>> searchItems(String query);
  Future<Either<Failure, int>> addItem(ItemEntity item);
  Future<Either<Failure, Unit>> updateItem(ItemEntity item);
  Future<Either<Failure, int>> deleteItem(int id);
}
