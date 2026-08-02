import 'package:isar/isar.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class ItemsLocalDataSource {
  Future<List<ItemModel>> getItems();
  Future<List<ItemModel>> searchItems(String query);
  Future<int> addItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<int> deleteItem(int id);
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ItemModelSchema],
      directory: dir.path,
    );
    return _isar!;
  }

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
