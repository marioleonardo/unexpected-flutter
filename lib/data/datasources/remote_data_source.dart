import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/data/models/point.dart';
import 'package:uuid/uuid.dart';

const String API_BASE = 'https://just-commonly-chigger.ngrok-free.app/api/points';

@injectable
class RemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio);

  Future<List<Point>> getPoints() async {
    try {
      final response = await dio.get(API_BASE);
      final res = (response.data as List<dynamic>)
          .map((json) => Point.fromJson(json as Map<String, dynamic>))
          .toList();
      return res;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Point> getPoint(String id) async {
    try {
      final response = await dio.get('$API_BASE/$id');
      return Point.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Point> createPoint(String label, double lat, double lng) async {
    try {
      final response = await dio.post(
        API_BASE,
        data: {
          'label': label,
          'lat': lat,
          'lng': lng,
        },
      );
      return Point.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Point> updatePoint(String id, String label, double lat, double lng) async {
    try {
      final response = await dio.put(
        '$API_BASE/$id',
        data: {
          'label': label,
          'lat': lat,
          'lng': lng,
        },
      );
      return Point.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deletePoint(String id) async {
    try {
      await dio.delete('$API_BASE/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return Exception('API Error: ${e.response!.statusCode} - ${e.response!.data}');
    } else {
      return Exception('Network Error: ${e.message}');
    }
  }
}
