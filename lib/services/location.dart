import 'package:geolocator/geolocator.dart';

class Location {
  double longitude = 0;
  double latitude = 0;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    longitude = position.longitude;
    latitude = position.latitude;
    print(position.toString());
  }
}
