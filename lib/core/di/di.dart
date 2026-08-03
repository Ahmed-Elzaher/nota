import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:nota/features/items/data/data_source/local_data_source.dart';
import 'package:nota/features/items/data/repository/items_repository_impl.dart';
import 'package:nota/features/items/domain/repository/items_repository.dart';
import 'package:nota/features/items/domain/use_case/add_item_use_case.dart';
import 'package:nota/features/items/domain/use_case/delete_item_use_case.dart';
import 'package:nota/features/items/domain/use_case/get_items_use_case.dart';
import 'package:nota/features/items/domain/use_case/search_items_use_case.dart';
import 'package:nota/features/items/domain/use_case/update_item_usecase.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/features/mind_map/data/data_source/mind_map_local_data_source.dart';
import 'package:nota/features/mind_map/data/repository/mind_map_repository_impl.dart';
import 'package:nota/features/mind_map/domain/repository/mind_map_repository.dart';
import 'package:nota/features/mind_map/presentation/controller/mind_maps_cubit.dart';
import 'package:nota/core/settings/app_settings_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpLocators() async {
  // Register Database Helper removed

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Register Core Services (Network, Database, etc.)
  
  // Register Repositories
  getIt.registerLazySingleton<ItemsLocalDataSource>(
    () => ItemsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ItemsRepository>(
    () => ItemsRepositoryImpl(getIt<ItemsLocalDataSource>()),
  );

  getIt.registerLazySingleton<MindMapLocalDataSource>(
    () => MindMapLocalDataSource(),
  );
  getIt.registerLazySingleton<MindMapRepository>(
    () => MindMapRepositoryImpl(getIt<MindMapLocalDataSource>()),
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
  getIt.registerLazySingleton<ItemsCubit>(
    () => ItemsCubit(
      getItemsUseCase: getIt<GetItemsUseCase>(),
      searchItemsUseCase: getIt<SearchItemsUseCase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      updateItemUseCase: getIt<UpdateItemUseCase>(),
      deleteItemUseCase: getIt<DeleteItemUseCase>(),
    ),
  );

  getIt.registerLazySingleton<MindMapsCubit>(
    () => MindMapsCubit(repository: getIt<MindMapRepository>()),
  );

  getIt.registerLazySingleton<AppSettingsCubit>(
    () => AppSettingsCubit(getIt<SharedPreferences>()),
  );
}
