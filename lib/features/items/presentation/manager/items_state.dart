import 'package:nota/features/items/data/models/item_model.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<ItemModel> items;
  ItemsLoaded(this.items);
}

class ItemsError extends ItemsState {
  final String message;
  ItemsError(this.message);
}
