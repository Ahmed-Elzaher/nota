import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/domain/repositories/items_repository.dart';

class SearchItemsUseCase {
  final ItemsRepository repository;

  SearchItemsUseCase(this.repository);

  Future<Either<String, List<ItemModel>>> call(String query) async {
    return await repository.searchItems(query);
  }
}
