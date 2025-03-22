import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/data/models/point.dart';

// @LazySingleton(as: LocalDataSource)
@injectable
class LocalDataSource {
  static const _pointsBox = 'points_box';
  static const _favoritesBox = 'favorites_box';

  Future<void> init() async {
    await Hive.openBox(_pointsBox);
    await Hive.openBox(_favoritesBox);
  }

  Future<List<Point>> getPoints() async {
    final box = Hive.box(_pointsBox);
    final pointsJsonString = box.get('points');
    if (pointsJsonString == null) return [];
    try {
      final List<dynamic> pointsJson = jsonDecode(pointsJsonString);
      return pointsJson.map((json) => Point.fromJson(json)).toList();
    } catch (e) {
      return []; // Return an empty list on error
    }
  }

  Future<void> savePoints(List<Point> points) async {
    final box = Hive.box(_pointsBox);
    final pointsJson = points.map((point) => point.toJson()).toList();
    await box.put('points', jsonEncode(pointsJson));
  }


  Future<void> addPoint(Point point) async {
    final points = await getPoints();
    points.add(point);
    await savePoints(points);
  }

  Future<void> updatePoint(Point updatedPoint) async {
     final points = await getPoints();
    final index = points.indexWhere((p) => p.id == updatedPoint.id);
    if (index != -1) {
      points[index] = updatedPoint;
      await savePoints(points);
    }
  }

    Future<void> deletePoint(String id) async {
    final points = await getPoints();
    points.removeWhere((p) => p.id == id);
    
    await savePoints(points);
  }



  Future<List<String>> getFavorites() async {
    final box = Hive.box(_favoritesBox);
    final favoritesJsonString = box.get('favorites');
    if (favoritesJsonString == null) return [];
     try {
    final List<dynamic> favoritesJson = jsonDecode(favoritesJsonString);
    return favoritesJson.cast<String>();
     } catch (e) {
      return []; // Return empty list in case of error.
    }
  }

  Future<void> _saveFavorites(List<String> favorites) async {
    final box = Hive.box(_favoritesBox);
    await box.put('favorites', jsonEncode(favorites));
  }

  Future<void> addFavorite(String pointId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(pointId)) {
      favorites.add(pointId);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String pointId) async {
    final favorites = await getFavorites();
    favorites.remove(pointId);
    await _saveFavorites(favorites);
  }
}