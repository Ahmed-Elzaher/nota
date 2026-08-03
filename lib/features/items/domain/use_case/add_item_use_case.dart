import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class AddItemUseCase {
  final ItemsRepository repository;

  AddItemUseCase(this.repository);

  Future<Either<Failure, int>> call(ItemEntity item) {
    return repository.addItem(item);
  }
}
