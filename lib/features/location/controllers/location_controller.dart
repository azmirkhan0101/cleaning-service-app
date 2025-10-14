import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  TextEditingController selectedAddress = TextEditingController();
  var selectedLatitude = 0.0.obs;
  var selectedLongitude = 0.0.obs;

  // Search related
  final searchResults = <Map<String, dynamic>>[].obs;
  final showSearchResults = false.obs;
  final isSearching = false.obs;

  void updateLocation(String address, double latitude, double longitude) {
    selectedAddress.text = address;
    selectedLatitude.value = latitude;
    selectedLongitude.value = longitude;
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty || query.length < 3) {
      searchResults.clear();
      showSearchResults.value = false;
      return;
    }

    isSearching.value = true;

    try {
      // Search with multiple variations for better results
      List<String> searchQueries = [
        query,
        "$query, USA",
        "$query city",
        "$query state",
      ];

      Set<Map<String, dynamic>> uniqueResults = {};

      for (String searchQuery in searchQueries) {
        try {
          List<Location> locations = await locationFromAddress(
            searchQuery,
          ).timeout(Duration(seconds: 3));

          for (var location in locations.take(10)) {
            try {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                location.latitude,
                location.longitude,
              ).timeout(Duration(seconds: 2));

              if (placemarks.isNotEmpty) {
                Placemark place = placemarks[0];

                // Build detailed address
                List<String> addressParts = [];
                if (place.name != null && place.name!.isNotEmpty) {
                  addressParts.add(place.name!);
                }
                if (place.street != null &&
                    place.street!.isNotEmpty &&
                    place.street != place.name) {
                  addressParts.add(place.street!);
                }
                if (place.subLocality != null &&
                    place.subLocality!.isNotEmpty) {
                  addressParts.add(place.subLocality!);
                }
                if (place.locality != null && place.locality!.isNotEmpty) {
                  addressParts.add(place.locality!);
                }
                if (place.administrativeArea != null &&
                    place.administrativeArea!.isNotEmpty) {
                  addressParts.add(place.administrativeArea!);
                }
                if (place.country != null && place.country!.isNotEmpty) {
                  addressParts.add(place.country!);
                }

                String fullAddress = addressParts.join(', ');

                // Create unique key to avoid duplicates
                String key =
                    "${location.latitude.toStringAsFixed(4)}_${location.longitude.toStringAsFixed(4)}";

                // Add to set if not duplicate
                if (!uniqueResults.any((r) => r['key'] == key)) {
                  // Determine main and secondary text
                  String mainText =
                      place.name ?? place.street ?? place.locality ?? 'Unknown';
                  String secondaryText = [
                    if (place.locality != null && place.locality != mainText)
                      place.locality,
                    if (place.administrativeArea != null)
                      place.administrativeArea,
                    if (place.country != null) place.country,
                  ].join(', ');

                  uniqueResults.add({
                    'key': key,
                    'address': fullAddress,
                    'main_text': mainText,
                    'secondary_text': secondaryText,
                    'latitude': location.latitude,
                    'longitude': location.longitude,
                  });
                }

                // Stop if we have enough results
                if (uniqueResults.length >= 15) break;
              }
            } catch (e) {
              continue;
            }
          }

          if (uniqueResults.length >= 15) break;
        } catch (e) {
          continue;
        }
      }

      searchResults.value = uniqueResults.take(15).toList();
      showSearchResults.value = searchResults.isNotEmpty;
    } catch (e) {
      print("Error searching locations: $e");
      searchResults.clear();
      showSearchResults.value = false;
    } finally {
      isSearching.value = false;
    }
  }

  void selectSearchResult(Map<String, dynamic> result) {
    updateLocation(result['address'], result['latitude'], result['longitude']);
    clearSearchResults();
  }

  void clearSearchResults() {
    searchResults.clear();
    showSearchResults.value = false;
  }

  @override
  void onClose() {
    selectedAddress.dispose();
    super.onClose();
  }
}
