import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pointz/application/bloc/favorite/favorite_bloc.dart';
import 'package:pointz/application/bloc/point/point_bloc.dart';
import 'package:pointz/data/models/point.dart';
import 'package:pointz/di/injection.dart';
import 'package:pointz/presentation/screens/map_screen.dart';
import 'package:pointz/presentation/screens/point_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/datasources/local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  await Hive.initFlutter();
  configureDependencies(); // Initialize dependency injection
  await getIt<LocalDataSource>().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MapScreen(),
      ),
GoRoute(
        path: '/point/:id',
        builder: (context, state) {
          final pointId = state.pathParameters['id']!; // Get the ID
          return PointDetailScreen(pointId: pointId); // Pass the ID
        },
      ),

    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.instance<PointBloc>()..add(LoadPoints()),
        ),
        BlocProvider(
          create: (context) =>
              GetIt.instance<FavoriteBloc>()..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Pointz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}