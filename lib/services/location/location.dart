import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check & request permissions, then return the current position.
  static Future<Position> getCurrentLocation() async {
    // 1. Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 2. Check permission status.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permissions if denied.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied.
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // 3. Everything ok: get the position with high accuracy via LocationSettings.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
