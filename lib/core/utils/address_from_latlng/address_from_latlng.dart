import 'package:geocoding/geocoding.dart';

class AddressFromLatLng {
  static Future<String?> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placeMark.isNotEmpty) {
      final Placemark place = placeMark[0];
      final address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
      return address;
    }

    return null;
  }
}
