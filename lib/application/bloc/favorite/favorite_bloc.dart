import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/domain/repositories/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

@injectable
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc(this.favoriteRepository) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoritesLoading());
    try {
      final favorites = await favoriteRepository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoriteState> emit) async {
    // No loading state here, as it's a quick local operation
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      try {
        await favoriteRepository.toggleFavorite(event.pointId);
        final newFavorites = List<String>.from(currentState.favorites);
        if (newFavorites.contains(event.pointId)) {
          newFavorites.remove(event.pointId);
        } else {
          newFavorites.add(event.pointId);
        }
        emit(FavoritesLoaded(favorites: newFavorites));
      } catch (e) {
        emit(FavoritesError(message: e.toString()));
      }
    }
  }
}