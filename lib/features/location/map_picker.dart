import 'dart:async';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PickerMapScreen extends StatefulWidget {
  const PickerMapScreen({super.key});

  @override
  State<PickerMapScreen> createState() => _PickerMapScreenState();
}

class _PickerMapScreenState extends State<PickerMapScreen> {
  // location controller
  final LocationController locationController = Get.put(LocationController());

  // Google Map controller
  late GoogleMapController mapController;
  LatLng _selectedLocation = LatLng(
    37.7749,
    -122.4194,
  ); // Default San Francisco
  String _selectedAddress = "";

  final LatLng _defaultLocation = LatLng(37.7749, -122.4194); // San Francisco

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );

      // Get initial address
      await _getAddressFromLatLng(_selectedLocation);
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

        setState(() {
          _selectedAddress = address;
          locationController.selectedAddress.text =
              address; // Update controller
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  void _onCameraMove(CameraPosition position) {
    _selectedLocation = position.target;
  }

  void _onCameraIdle() {
    // Get address when user stops moving the map
    _getAddressFromLatLng(_selectedLocation);
  }

  void _onSearchResultSelected() {
    // When user selects a search result, move map to that location
    if (locationController.selectedLatitude.value != 0.0) {
      LatLng location = LatLng(
        locationController.selectedLatitude.value,
        locationController.selectedLongitude.value,
      );

      setState(() {
        _selectedLocation = location;
        _selectedAddress = locationController.selectedAddress.text;
      });

      mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
    }
  }

  void _confirmLocation() {
    // Print the selected location details
    debugPrint("===== SELECTED LOCATION =====");
    debugPrint("Latitude: ${_selectedLocation.latitude}");
    debugPrint("Longitude: ${_selectedLocation.longitude}");
    debugPrint("Address: $_selectedAddress");
    debugPrint("============================");
    // Update the location controller with the selected location
    locationController.updateLocation(
      _selectedAddress,
      _selectedLocation.latitude,
      _selectedLocation.longitude,
    );

    Get.back();

    // You can also return the data or navigate back with the result
    // Navigator.pop(context, {
    //   'latitude': _selectedLocation.latitude,
    //   'longitude': _selectedLocation.longitude,
    //   'address': _selectedAddress,
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Select Location", leftIcon: true),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 10,
            ),
            myLocationEnabled: true, // Show user location
            myLocationButtonEnabled: false, // Disable default button
            zoomControlsEnabled: false, // Hide zoom in/out buttons
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),

          // Center Marker (Pin Icon)
          Center(child: Icon(Icons.location_pin, size: 50, color: Colors.red)),

          // Search Widget
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: LocationSearchWidget(
              controller: locationController,
              hintText: "Search for a location...",
              onResultSelected: _onSearchResultSelected,
            ),
          ),

          // OK Button and Current Location Button Row
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // OK Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4899D1),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "OK - Confirm Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),
                // Current Location Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: getUserCurrentLocation,
                    icon: Icon(
                      Icons.my_location,
                      color: Color(0xFF4899D1),
                      size: 28,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
