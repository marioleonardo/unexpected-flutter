# Points Map App

A Flutter application that allows users to create, read, update, and delete points on a map to create their own custom map. Points can be viewed offline and added to a locally managed favorites list.

## Features

- View, create, modify, and delete points on a Google Map
- Add points to favorites (stored locally)
- Offline point viewing capability
- Long press on map to add new points
- Bottom sheet dialog for point interactions
- Red markers for normal points, blue for favorites

## Technical Implementation

- **State Management**: BLoC pattern
- **Dependency Injection**: GetIt with Injectable
- **HTTP Client**: Dio
- **Map Integration**: Google Maps API
- **Data Models**: Freezed with json_serializable
- **Navigation**: go_router

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Usage

- **Add Point**: Long press on the map
- **View Point Details**: Tap on any marker
- **Modify/Delete**: Use options in bottom sheet dialog
- **Add to Favorites**: Toggle favorite in point details

## APIs

The application uses the following endpoints:

```
[POST]   https://just-commonly-chigger.ngrok-free.app/api/points
[GET]    https://just-commonly-chigger.ngrok-free.app/api/points
[GET]    https://just-commonly-chigger.ngrok-free.app/api/points/:id
[DELETE] https://just-commonly-chigger.ngrok-free.app/api/points/:id
[PUT]    https://just-commonly-chigger.ngrok-free.app/api/points/:id
```

## Note

- Application tested on Android platform
- Location permissions required for full functionality