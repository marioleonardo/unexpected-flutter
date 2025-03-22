part of 'point_bloc.dart';

abstract class PointState extends Equatable {
  const PointState();

  @override
  List<Object> get props => [];
}

class PointInitial extends PointState {}

class PointsLoading extends PointState {}
class PointLoading extends PointState {}

class PointLoaded extends PointState {
  final Point point;

  const PointLoaded({required this.point});

  @override
  List<Object> get props => [point];
}

class PointsLoaded extends PointState {
  final List<Point> points;

  const PointsLoaded({required this.points});

  @override
  List<Object> get props => [points];
}

class PointsError extends PointState {
  final String message;

  const PointsError({required this.message});

  @override
  List<Object> get props => [message];
}