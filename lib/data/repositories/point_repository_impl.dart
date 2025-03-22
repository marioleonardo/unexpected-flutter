import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/data/datasources/local_data_source.dart';
import 'package:pointz/data/datasources/remote_data_source.dart';
import 'package:pointz/data/models/point.dart';
import 'package:pointz/domain/repositories/point_repository.dart';

@Injectable(as: PointRepository)
class PointRepositoryImpl implements PointRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Connectivity connectivity;
  // @factoryMethod
  PointRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

 @override
  Future<List<Point>> getPoints() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final points = await remoteDataSource.getPoints();
        await localDataSource.savePoints(points); // Update local cache
        return points;
      } catch (e) {
        return localDataSource.getPoints();
      }
    } else {
      // No internet, use local data
      return localDataSource.getPoints();
    }
  }

  @override
  Future<Point> createPoint(String label, double lat, double lng) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
    final point = await remoteDataSource.createPoint(label, lat, lng);
    await localDataSource.addPoint(point); // Add to local cache
    return point;
  }


  @override
  Future<Point> updatePoint(String id, String label, double lat, double lng) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    final updatedPoint =
        await remoteDataSource.updatePoint(id, label, lat, lng);
        await localDataSource.updatePoint(updatedPoint);
    return updatedPoint;
  }

  @override
  Future<void> deletePoint(String id) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
    await remoteDataSource.deletePoint(id);
    await localDataSource.deletePoint(id); // Remove from local cache
    
  }

    @override
  Future<Point> getPoint(String id) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final point = await remoteDataSource.getPoint(id);
        return point;
      } catch (e) {
        // If remote fails, fallback to local data
        final points = await localDataSource.getPoints();
        return points.firstWhere((p) => p.id == id);
      }
    } else {
      final points = await localDataSource.getPoints();
       return points.firstWhere((p) => p.id == id);
    }
  }

}