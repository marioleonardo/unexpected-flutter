part of 'point_bloc.dart';

abstract class PointEvent extends Equatable {
  const PointEvent();

  @override
  List<Object> get props => [];
}

class LoadPoints extends PointEvent {}
class LoadPoint extends PointEvent {
  final String id;

  const LoadPoint(this.id);

   @override
  List<Object> get props => [id];
}
class AddPoint extends PointEvent {
  final String label;
  final double lat;
  final double lng;

  const AddPoint({
    required this.label,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [label, lat, lng];
}

class UpdatePointEvent extends PointEvent {
  final String id;
  final String label;
  final double lat;
  final double lng;

  const UpdatePointEvent({
    required this.id,
    required this.label,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [id, label, lat, lng];
}

class DeletePointEvent extends PointEvent {
  final String id;

  const DeletePointEvent(this.id);

  @override
  List<Object> get props => [id];
}