import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class UpdateItemUseCase {
  final ItemsRepository repository;

  UpdateItemUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ItemEntity item) {
    return repository.updateItem(item);
  }
}
