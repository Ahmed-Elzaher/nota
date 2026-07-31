import 'package:nota/core/database/database_helper.dart';
import 'package:nota/features/items/data/models/item_model.dart';

abstract class ItemsLocalDataSource {
  Future<List<ItemModel>> getItems();
  Future<List<ItemModel>> searchItems(String query);
  Future<int> addItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<int> deleteItem(int id);
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  final DatabaseHelper databaseHelper;

  ItemsLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<ItemModel>> getItems() async {
    final maps = await databaseHelper.queryAllItems();
    return maps.map((map) => ItemModel.fromMap(map)).toList();
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    final maps = await databaseHelper.searchItems(query);
    return maps.map((map) => ItemModel.fromMap(map)).toList();
  }

  @override
  Future<int> addItem(ItemModel item) async {
    return await databaseHelper.insertItem(item.toMap());
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    await databaseHelper.updateItem(item.toMap());
  }

  @override
  Future<int> deleteItem(int id) async {
    return await databaseHelper.deleteItem(id);
  }
}
