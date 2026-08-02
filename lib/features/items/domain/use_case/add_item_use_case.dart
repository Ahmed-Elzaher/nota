import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class AddItemUseCase {
  final ItemsRepository repository;

  AddItemUseCase(this.repository);

  Future<Either<String, int>> call(ItemModel item) async {
    return await repository.addItem(item);
  }
}
