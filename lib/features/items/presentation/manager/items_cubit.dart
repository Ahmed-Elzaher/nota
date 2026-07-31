import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/domain/use_cases/add_item_use_case.dart';
import 'package:nota/features/items/domain/use_cases/delete_item_use_case.dart';
import 'package:nota/features/items/domain/use_cases/get_items_use_case.dart';
import 'package:nota/features/items/domain/use_cases/search_items_use_case.dart';
import 'package:nota/features/items/domain/usecases/update_item_usecase.dart';
import 'package:nota/features/items/presentation/manager/items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final GetItemsUseCase getItemsUseCase;
  final SearchItemsUseCase searchItemsUseCase;
  final AddItemUseCase addItemUseCase;
  final UpdateItemUseCase updateItemUseCase;
  final DeleteItemUseCase deleteItemUseCase;

  List<ItemModel> allItems = []; // in-memory cache for filtering
  String currentCategory = 'الكل';

  ItemsCubit({
    required this.getItemsUseCase,
    required this.searchItemsUseCase,
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.deleteItemUseCase,
  }) : super(ItemsInitial());

  Future<void> fetchItems() async {
    emit(ItemsLoading());
    final result = await getItemsUseCase.call();
    result.fold(
      (error) => emit(ItemsError(error)),
      (items) {
        allItems = items;
        _emitFilteredItems();
      },
    );
  }

  void filterByCategory(String category) {
    currentCategory = category;
    _emitFilteredItems();
  }

  void _emitFilteredItems() {
    if (currentCategory == 'الكل') {
      emit(ItemsLoaded(allItems));
    } else {
      final filtered = allItems.where((i) => i.category == currentCategory).toList();
      emit(ItemsLoaded(filtered));
    }
  }

  Future<void> searchItems(String query) async {
    if (query.isEmpty) {
      fetchItems();
      return;
    }
    emit(ItemsLoading());
    final result = await searchItemsUseCase.call(query);
    result.fold(
      (error) => emit(ItemsError(error)),
      (items) => emit(ItemsLoaded(items)),
    );
  }

  Future<void> addItem(ItemModel item) async {
    final result = await addItemUseCase.call(item);
    result.fold(
      (error) => emit(ItemsError(error)),
      (id) => fetchItems(),
    );
  }

  Future<void> updateItem(ItemModel item) async {
    final result = await updateItemUseCase.call(item);
    result.fold(
      (error) => emit(ItemsError(error)),
      (_) => fetchItems(),
    );
  }

  Future<void> deleteItem(int id) async {
    final result = await deleteItemUseCase.call(id);
    result.fold(
      (error) => emit(ItemsError(error)),
      (_) => fetchItems(),
    );
  }
}
