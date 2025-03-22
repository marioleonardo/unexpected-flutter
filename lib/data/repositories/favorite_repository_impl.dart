import 'package:injectable/injectable.dart';
import 'package:pointz/data/datasources/local_data_source.dart';
import 'package:pointz/domain/repositories/favorite_repository.dart';

@Injectable(as: FavoriteRepository)
class FavoriteRepositoryImpl implements FavoriteRepository {
  final LocalDataSource localDataSource;

  FavoriteRepositoryImpl(this.localDataSource);

  @override
  Future<List<String>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> toggleFavorite(String pointId) async {
    final favorites = await localDataSource.getFavorites();
    if (favorites.contains(pointId)) {
      await localDataSource.removeFavorite(pointId);
    } else {
      await localDataSource.addFavorite(pointId);
    }
  }
}