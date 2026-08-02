import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/model/item_model.dart';

abstract class ItemsRepository {
  Future<Either<String, List<ItemModel>>> getItems();
  Future<Either<String, List<ItemModel>>> searchItems(String query);
  Future<Either<String, int>> addItem(ItemModel item);
  Future<Either<String, Unit>> updateItem(ItemModel item);
  Future<Either<String, int>> deleteItem(int id);
}
