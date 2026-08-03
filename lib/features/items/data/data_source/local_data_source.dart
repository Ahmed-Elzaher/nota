import 'package:isar/isar.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/core/services/database_service.dart';

abstract class ItemsLocalDataSource {
  Future<List<ItemModel>> getItems();
  Future<List<ItemModel>> searchItems(String query);
  Future<int> addItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<int> deleteItem(int id);
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  Future<Isar> get isar => DatabaseService.instance.database;

  @override
  Future<List<ItemModel>> getItems() async {
    final isarInstance = await isar;
    return await isarInstance.itemModels.where().sortByCreatedAtDesc().findAll();
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    final isarInstance = await isar;
    return await isarInstance.itemModels
        .filter()
        .contentContains(query, caseSensitive: false)
        .or()
        .tagsContains(query, caseSensitive: false)
        .findAll();
  }

  @override
  Future<int> addItem(ItemModel item) async {
    final isarInstance = await isar;
    return await isarInstance.writeTxn(() async {
      return await isarInstance.itemModels.put(item);
    });
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    final isarInstance = await isar;
    await isarInstance.writeTxn(() async {
      await isarInstance.itemModels.put(item);
    });
  }

  @override
  Future<int> deleteItem(int id) async {
    final isarInstance = await isar;
    await isarInstance.writeTxn(() async {
      await isarInstance.itemModels.delete(id);
    });
    return 1;
  }
}
