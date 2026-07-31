import 'package:dartz/dartz.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/domain/repositories/items_repository.dart';

class GetItemsUseCase {
  final ItemsRepository repository;

  GetItemsUseCase(this.repository);

  Future<Either<String, List<ItemModel>>> call() async {
    return await repository.getItems();
  }
}
