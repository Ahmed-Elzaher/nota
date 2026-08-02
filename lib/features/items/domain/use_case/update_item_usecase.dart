import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class UpdateItemUseCase {
  final ItemsRepository repository;

  UpdateItemUseCase(this.repository);

  Future<Either<String, Unit>> call(ItemModel item) async {
    return await repository.updateItem(item);
  }
}
