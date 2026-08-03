import 'package:isar/isar.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/features/mind_map/data/model/mind_map_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Isar? _isar;

  Future<Isar> get database async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ItemModelSchema, MindMapModelSchema],
      directory: dir.path,
    );
    return _isar!;
  }
}
