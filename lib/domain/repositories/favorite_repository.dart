abstract class FavoriteRepository {
  Future<List<String>> getFavorites();
  Future<void> toggleFavorite(String pointId);
}