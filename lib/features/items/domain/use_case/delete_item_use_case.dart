import 'package:dartz/dartz.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class DeleteItemUseCase {
  final ItemsRepository repository;

  DeleteItemUseCase(this.repository);

  Future<Either<String, int>> call(int id) async {
    return await repository.deleteItem(id);
  }
}
