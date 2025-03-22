import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pointz/data/models/point.dart';
import 'package:pointz/domain/repositories/point_repository.dart';


part 'point_event.dart';
part 'point_state.dart';

@injectable
class PointBloc extends Bloc<PointEvent, PointState> {
  final PointRepository pointRepository;

  PointBloc(this.pointRepository) : super(PointInitial()) {
    on<LoadPoints>(_onLoadPoints);
    on<LoadPoint>(_onLoadPoint);
    on<AddPoint>(_onAddPoint);
    on<UpdatePointEvent>(_onUpdatePoint);
    on<DeletePointEvent>(_onDeletePoint);
  }

  Future<void> _onLoadPoint(LoadPoint event, Emitter<PointState> emit) async {
    emit(PointLoading());
    try {
      final point = await pointRepository.getPoint(event.id);
      emit(PointLoaded(point: point));
    } catch (e) {
      emit(PointsError(message: e.toString()));
    }
  }

  Future<void> _onLoadPoints(LoadPoints event, Emitter<PointState> emit) async {
    emit(PointsLoading());
    try {
      final points = await pointRepository.getPoints();
      emit(PointsLoaded(points: points));
    } catch (e) {
      emit(PointsError(message: e.toString()));
    }
  }

  Future<void> _onAddPoint(AddPoint event, Emitter<PointState> emit) async {
    emit (PointsLoading()); // Indicate loading
    try {
      final point = await pointRepository.createPoint(
        event.label,
        event.lat,
        event.lng,
      );
      final currentState = state;
      if (currentState is PointsLoaded) {
        emit(PointsLoaded(points: [...currentState.points, point]));
      } else {
 // If not already loaded, reload all points (less efficient, but simpler)
        add(LoadPoints()); 
      }
    } catch (e) {
      emit(PointsError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePoint(
      UpdatePointEvent event, Emitter<PointState> emit) async {
    // emit(PointsLoading()); //Add this
    try {
      final updatedPoint = await pointRepository.updatePoint(
        event.id,
        event.label,
        event.lat,
        event.lng,
      );
      final currentState = state;
      if (currentState is PointsLoaded) {
        final index = currentState.points.indexWhere((p) => p.id == event.id);
        if (index != -1) {
          final updatedPoints = List<Point>.from(currentState.points);
          updatedPoints[index] = updatedPoint;
          emit(PointsLoaded(points: updatedPoints));
        }
      }
    } catch (e) {
      emit(PointsError(message: e.toString()));
    }
  }

  Future<void> _onDeletePoint(
      DeletePointEvent event, Emitter<PointState> emit) async {
        // emit(PointsLoading()); //Add this
    try {
      await pointRepository.deletePoint(event.id);
      // emit(PointsLoaded(points: [])); //Add this
      final currentState = state;
      if (currentState is PointsLoaded) {

        final updatedPoints =
            currentState.points.where((p) => p.id != event.id).toList();

        emit(PointsLoaded(points: updatedPoints));
      }

    } catch (e) {

      emit(PointsError(message: e.toString()));
    }
  }
}