import 'package:pointz/data/models/point.dart';

abstract class PointRepository {
  Future<List<Point>> getPoints();
  Future<Point> createPoint(String label, double lat, double lng);
  Future<Point> updatePoint(String id, String label, double lat, double lng);
  Future<void> deletePoint(String id);
  Future<Point> getPoint(String id);
}