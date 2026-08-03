import 'package:nota/features/mind_map/data/model/mind_map_model.dart';
import 'package:isar/isar.dart';

import 'package:nota/core/services/database_service.dart';

class MindMapLocalDataSource {
  Future<Isar> get isar => DatabaseService.instance.database;

  Future<List<MindMapModel>> getMindMaps() async {
    final isarInstance = await isar;
    return await isarInstance.mindMapModels.where().findAll();
  }

  Future<int> saveMindMap(MindMapModel mindMap) async {
    final isarInstance = await isar;
    return await isarInstance.writeTxn(() async {
      return await isarInstance.mindMapModels.put(mindMap);
    });
  }

  Future<bool> deleteMindMap(int id) async {
    final isarInstance = await isar;
    return await isarInstance.writeTxn(() async {
      return await isarInstance.mindMapModels.delete(id);
    });
  }
}
