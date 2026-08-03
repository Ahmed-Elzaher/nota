import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class DeleteItemUseCase {
  final ItemsRepository repository;

  DeleteItemUseCase(this.repository);

  Future<Either<Failure, int>> call(int id) {
    return repository.deleteItem(id);
  }
}
