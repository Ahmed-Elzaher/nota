import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/domain/use_case/add_item_use_case.dart';
import 'package:nota/features/items/domain/use_case/delete_item_use_case.dart';
import 'package:nota/features/items/domain/use_case/get_items_use_case.dart';
import 'package:nota/features/items/domain/use_case/search_items_use_case.dart';
import 'package:nota/features/items/domain/use_case/update_item_usecase.dart';
import 'package:nota/features/items/presentation/controller/items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final GetItemsUseCase getItemsUseCase;
  final SearchItemsUseCase searchItemsUseCase;
  final AddItemUseCase addItemUseCase;
  final UpdateItemUseCase updateItemUseCase;
  final DeleteItemUseCase deleteItemUseCase;

  List<ItemEntity> allItems = []; // in-memory cache for filtering
  String currentCategory = 'الكل';

  ItemsCubit({
    required this.getItemsUseCase,
    required this.searchItemsUseCase,
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.deleteItemUseCase,
  }) : super(ItemsInitial());

  List<String> get uniqueCategories {
    return allItems
        .map((e) => e.category)
        .where((c) => c != 'الكل' && c != 'برمجة' && c != 'مشاريع' && c != 'دراسة' && c != 'أفكار' && c != 'أخرى')
        .toSet()
        .toList();
  }

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

  Future<void> addItem(ItemEntity item) async {
    final result = await addItemUseCase.call(item);
    result.fold(
      (error) {
        emit(ItemsError(error));
        _emitFilteredItems();
      },
      (id) {
        item.id = id;
        allItems.insert(0, item);
        _emitFilteredItems();
      },
    );
  }

  Future<void> updateItem(ItemEntity item) async {
    final result = await updateItemUseCase.call(item);
    result.fold(
      (error) {
        emit(ItemsError(error));
        _emitFilteredItems();
      },
      (_) {
        final index = allItems.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          allItems[index] = item;
          _emitFilteredItems();
        }
      },
    );
  }

  Future<void> deleteItem(int id) async {
    final result = await deleteItemUseCase.call(id);
    result.fold(
      (error) {
        emit(ItemsError(error));
        _emitFilteredItems();
      },
      (_) {
        allItems.removeWhere((i) => i.id == id);
        _emitFilteredItems();
      },
    );
  }
}
