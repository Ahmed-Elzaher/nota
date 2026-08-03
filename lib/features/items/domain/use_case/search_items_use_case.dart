import 'package:dartz/dartz.dart';
import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';

class SearchItemsUseCase {
  final ItemsRepository repository;

  SearchItemsUseCase(this.repository);

  Future<Either<Failure, List<ItemEntity>>> call(String query) {
    return repository.searchItems(query);
  }
}
