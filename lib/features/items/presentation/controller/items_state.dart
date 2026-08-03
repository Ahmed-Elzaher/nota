import 'package:nota/core/utils/errors/failures.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';

sealed class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<ItemEntity> items;
  ItemsLoaded(this.items);
}

class ItemsError extends ItemsState {
  final Failure failure;
  ItemsError(this.failure);
}
