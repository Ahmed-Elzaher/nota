import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nota/core/database/database_helper.dart';

import 'package:nota/features/items/data/data_sources/local_data_source.dart';
import 'package:nota/features/items/data/repositories/items_repository_impl.dart';
import 'package:nota/features/items/domain/repositories/items_repository.dart';
import 'package:nota/features/items/domain/use_cases/add_item_use_case.dart';
import 'package:nota/features/items/domain/use_cases/delete_item_use_case.dart';
import 'package:nota/features/items/domain/use_cases/get_items_use_case.dart';
import 'package:nota/features/items/domain/use_cases/search_items_use_case.dart';
import 'package:nota/features/items/domain/usecases/update_item_usecase.dart';
import 'package:nota/features/items/presentation/manager/items_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpLocators() async {
  // Register Database Helper
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database; // init db
  getIt.registerLazySingleton<DatabaseHelper>(() => databaseHelper);

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Register Core Services (Network, Database, etc.)
  
  // Register Repositories
  getIt.registerLazySingleton<ItemsLocalDataSource>(
    () => ItemsLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );
  getIt.registerLazySingleton<ItemsRepository>(
    () => ItemsRepositoryImpl(getIt<ItemsLocalDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetItemsUseCase>(
    () => GetItemsUseCase(getIt<ItemsRepository>()),
  );
  getIt.registerLazySingleton<SearchItemsUseCase>(
    () => SearchItemsUseCase(getIt<ItemsRepository>()),
  );
  getIt.registerLazySingleton<AddItemUseCase>(
    () => AddItemUseCase(getIt<ItemsRepository>()),
  );
  getIt.registerLazySingleton<UpdateItemUseCase>(
    () => UpdateItemUseCase(getIt<ItemsRepository>()),
  );
  getIt.registerLazySingleton<DeleteItemUseCase>(
    () => DeleteItemUseCase(getIt<ItemsRepository>()),
  );

  // Register Blocs/Cubits
  getIt.registerFactory<ItemsCubit>(
    () => ItemsCubit(
      getItemsUseCase: getIt<GetItemsUseCase>(),
      searchItemsUseCase: getIt<SearchItemsUseCase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      updateItemUseCase: getIt<UpdateItemUseCase>(),
      deleteItemUseCase: getIt<DeleteItemUseCase>(),
    ),
  );
}
