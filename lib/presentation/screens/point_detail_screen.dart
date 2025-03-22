import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pointz/application/bloc/point/point_bloc.dart';
import 'package:pointz/data/models/point.dart';
import 'package:pointz/presentation/widgets/point_bottom_sheet.dart';
import 'package:collection/collection.dart';

class PointDetailScreen extends StatefulWidget {
  final String pointId; // Get the pointId instead of the whole Point

  const PointDetailScreen({super.key, required this.pointId});

  @override
  State<PointDetailScreen> createState() => _PointDetailScreenState();
}

class _PointDetailScreenState extends State<PointDetailScreen> {

  @override
  void initState() {
    super.initState();
    // Dispatch an event to fetch the specific point.
    GetIt.instance<PointBloc>().add(LoadPoint(widget.pointId)); // Use GetIt here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Point Details")),
      body: BlocBuilder<PointBloc, PointState>(
        builder: (context, state) {
          if (state is PointLoading) {  // You'd have a PointLoading state

            return const Center(child: CircularProgressIndicator());
          } else if (state is PointLoaded) { // And a PointLoaded state.
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Label: ${state.point.label}',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Latitude: ${state.point.lat}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Longitude: ${state.point.lng}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          } 
            else if (state is PointsLoaded) { // You'd have a PointsLoaded state
            ("tarr");
            final point = state.points.firstWhereOrNull(
              (p) => p.id == widget.pointId,
            );
            if (point == null) {
              return const Center(child: Text('Point not found'));
            }
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Label: ${point.label}',
                  style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Latitude: ${point.lat}',
                  style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('Longitude: ${point.lng}',
                  style: Theme.of(context).textTheme.bodyMedium),
              ],
              ),
            );
            }

            // return const SizedBox.shrink(); // Or a placeholder
          // }
          // else if (state is PointsError) { //Show an error.

          //    return Center(child: Text('Error: ${state.message}'));
          // }
          else {

            return const SizedBox.shrink(); // Or a placeholder
          }
        },
      ),
    );
  }
}