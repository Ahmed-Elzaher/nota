import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';
import 'package:nota/features/mind_map/domain/repository/mind_map_repository.dart';
import 'package:nota/features/mind_map/presentation/controller/mind_maps_state.dart';

class MindMapsCubit extends Cubit<MindMapsState> {
  final MindMapRepository repository;

  MindMapsCubit({required this.repository}) : super(MindMapsInitial());

  Future<void> fetchMindMaps() async {
    emit(MindMapsLoading());
    final result = await repository.getMindMaps();
    result.fold(
      (failure) => emit(MindMapsError(failure)),
      (maps) => emit(MindMapsLoaded(maps)),
    );
  }

  Future<void> saveMindMap(MindMapEntity mindMap) async {
    final result = await repository.saveMindMap(mindMap);
    result.fold(
      (failure) => emit(MindMapsError(failure)),
      (id) {
        // Optimistic UI update or re-fetch
        fetchMindMaps();
      },
    );
  }

  Future<void> deleteMindMap(int id) async {
    final result = await repository.deleteMindMap(id);
    result.fold(
      (failure) => emit(MindMapsError(failure)),
      (_) => fetchMindMaps(),
    );
  }
}
