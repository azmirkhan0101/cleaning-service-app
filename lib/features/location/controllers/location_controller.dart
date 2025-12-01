import 'dart:convert';

import 'package:cleaning_service_app/features/location/models/place_autocomplete.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  TextEditingController selectedAddress = TextEditingController();
  var selectedLatitude = 0.0.obs;
  var selectedLongitude = 0.0.obs;

  // Search related
  // final searchResults =
  //     <Map<String, dynamic>>[].obs; // legacy, will be phased out
  final placePredictions = <PlacePrediction>[].obs;
  final showSearchResults = false.obs;
  final isSearching = false.obs;

  void updateLocation(String address, double latitude, double longitude) {
    selectedAddress.text = address;
    selectedLatitude.value = latitude;
    selectedLongitude.value = longitude;
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty || query.length < 3) {
      // searchResults.clear();
      showSearchResults.value = false;
      return;
    }

    isSearching.value = true;

    try {
      // Get API key from .env
      final apiKey = dotenv.env['MAPS_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Google Maps API key not found in .env file');
        isSearching.value = false;
        return;
      }

      // Google Places Autocomplete API endpoint
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$apiKey',
      );

      // Make API request
      final response = await http.get(url).timeout(Duration(seconds: 5));

      // debugPrint('Places API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['predictions'] != null) {
          final predictions = (data['predictions'] as List<dynamic>)
              .map((p) => PlacePrediction.fromJson(p as Map<String, dynamic>))
              .toList();

          // Limit to 10 results for UI
          placePredictions
            ..clear()
            ..addAll(predictions.take(10));

          // Keep legacy map empty to avoid mixed sources
          // searchResults.clear();
          showSearchResults.value = placePredictions.isNotEmpty;
        } else {
          // searchResults.clear();
          placePredictions.clear();
          showSearchResults.value = false;
        }
      } else {
        print('Failed to fetch places: ${response.statusCode}');
        // searchResults.clear();
        placePredictions.clear();
        showSearchResults.value = false;
      }
    } catch (e) {
      print("Error searching locations: $e");
      // searchResults.clear();
      placePredictions.clear();
      showSearchResults.value = false;
    } finally {
      isSearching.value = false;
    }
  }

  // Get place details including coordinates
  Future<Map<String, double>?> _getPlaceDetails(
    String placeId,
    String apiKey,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey',
      );

      final response = await http.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['result']?['geometry']?['location'] != null) {
          final location = data['result']['geometry']['location'];
          return {
            'lat': location['lat'].toDouble(),
            'lng': location['lng'].toDouble(),
          };
        }
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
    return null;
  }

  void selectSearchResult(Map<String, dynamic> result) {
    updateLocation(result['address'], result['latitude'], result['longitude']);
    clearSearchResults();
  }

  Future<void> selectPrediction(PlacePrediction prediction) async {
    final apiKey = dotenv.env['MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('Google Maps API key not found in .env file');
      return;
    }
    final details = await _getPlaceDetails(prediction.placeId, apiKey);
    if (details != null) {
      updateLocation(prediction.description, details['lat']!, details['lng']!);
      clearSearchResults();
    }
  }

  void clearSearchResults() {
    // searchResults.clear();
    placePredictions.clear();
    showSearchResults.value = false;
  }

  @override
  void onClose() {
    selectedAddress.dispose();
    super.onClose();
  }
}
