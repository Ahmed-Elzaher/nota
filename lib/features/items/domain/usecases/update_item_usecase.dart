import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/domain/repositories/items_repository.dart';

class UpdateItemUseCase {
  final ItemsRepository repository;

  UpdateItemUseCase(this.repository);

  Future<Either<String, Unit>> call(ItemModel item) async {
    return await repository.updateItem(item);
  }
}
