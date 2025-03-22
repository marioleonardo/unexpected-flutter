import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointz/application/bloc/favorite/favorite_bloc.dart';
import 'package:pointz/application/bloc/point/point_bloc.dart';
import 'package:pointz/data/models/point.dart';
import 'package:pointz/presentation/widgets/point_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(41.9028, 12.4964); // Default: Rome

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Get current location on startup
  }

   Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
     setState(() {
    _initialPosition = LatLng(position.latitude, position.longitude);
  });
    // Optionally move the camera to the current location
     mapController.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 15)); // Adjust zoom as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pointz')),
      body: BlocBuilder<PointBloc, PointState>(
        builder: (context, pointState) {
          return BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favoriteState) {
              List<Point> points = [];
              List<String> favorites = [];

              if (pointState is PointsLoaded) {
                points = pointState.points;
              }
              if (favoriteState is FavoritesLoaded) {
                favorites = favoriteState.favorites;
              }

              // Handle loading and error states
              if (pointState is PointsLoading) {
                // GetIt.instance<PointBloc>()..add(LoadPoints());
                return const Center(child: CircularProgressIndicator());
              }
              if (pointState is PointsError) {
                // return Center(child: Text('Error: ${pointState.message}'));
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 10,
                ),
                markers: _buildMarkers(points, favorites),
                onLongPress: (LatLng position) => _showAddPointDialog(position),
                onMapCreated: (controller) => mapController = controller,
                 myLocationEnabled: true, // Show user's location
                 myLocationButtonEnabled: true, // Show location button
              );
            },
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers(List<Point> points, List<String> favorites) {
    return points.map((point) {
      return Marker(
        markerId: MarkerId(point.id),
        position: LatLng(point.lat, point.lng),
        infoWindow: InfoWindow(title: point.label),
        icon: favorites.contains(point.id)
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            : BitmapDescriptor.defaultMarker,
        onTap: () => _showPointBottomSheet(point, favorites.contains(point.id)),
      );
    }).toSet();
  }

    void _showAddPointDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (context) {
        String label = '';
        return AlertDialog(
          title: const Text('Add Point'),
          content: TextField(
            onChanged: (value) => label = value,
            decoration: const InputDecoration(hintText: 'Label'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (label.isNotEmpty) {
                  // Use Uuid to generate a unique ID
                  String id = Uuid().v4();
                  context.read<PointBloc>().add(
                        AddPoint(
                          label: label,
                          lat: position.latitude,
                          lng: position.longitude,
                        ),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

//In the map screen

void _showPointBottomSheet(Point point, bool isFavorite) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PointBottomSheet(
        point: point,
        isFavorite: isFavorite,
        onEdit: () {
           Navigator.pop(context);
          _navigateToEditPoint(point);
          },
        onDelete: () {
          // No need to check for connectivity here, the Bloc handles it.
          context.read<PointBloc>().add(DeletePointEvent(point.id));
           Navigator.pop(context);
        },
        onToggleFavorite: () =>
            context.read<FavoriteBloc>().add(ToggleFavorite(point.id)),
        onViewDetails: () {
          Navigator.pop(context); // Close the bottom sheet
          context.push('/point/${point.id}'); // Pass only the ID
        },
      ),
    );
  }

  

   void _navigateToEditPoint(Point point) {
    showDialog(
      context: context,
      builder: (context) {
        String newLabel = point.label;
        return AlertDialog(
          title: const Text('Edit Point'),
          content: TextField(
            controller: TextEditingController(text: point.label),
            onChanged: (value) => newLabel = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newLabel.isNotEmpty) {
                  context.read<PointBloc>().add(
                        UpdatePointEvent(
                          id: point.id,
                          label: newLabel,
                          lat: point.lat,
                          lng: point.lng,
                        ),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}