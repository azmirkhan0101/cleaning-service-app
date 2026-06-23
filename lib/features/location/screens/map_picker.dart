import 'dart:async';

import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  LatLng _selectedLocation = const LatLng(
    37.7749,
    -122.4194,
  ); // Default San Francisco
  String _selectedAddress = "";
  bool _skipNextReverseGeocode = false;

  final LocationController _locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    // If a location is already selected (from profile), use it; else fallback to current location
    final presetLat = _locationController.selectedLatitude.value;
    final presetLng = _locationController.selectedLongitude.value;
    final presetAddress = _locationController.selectedAddress.text;
    if ((presetLat != 0.0 || presetLng != 0.0) && presetAddress.isNotEmpty) {
      _selectedLocation = LatLng(presetLat, presetLng);
      _selectedAddress = presetAddress;
      // Map controller isn't ready yet; onMapCreated animates to _selectedLocation
    } else {
      getUserCurrentLocation();
    }
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

      _skipNextReverseGeocode = true;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );

      // Get address for current location and update controller + search text
      await _getAddressFromLatLng(_selectedLocation);
      final address = _selectedAddress;
      locationController.updateLocation(
        address,
        _selectedLocation.latitude,
        _selectedLocation.longitude,
      );
      // Ensure any focused input is dismissed
      if (mounted) FocusScope.of(context).unfocus();
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
        final parts = <String?>[
          // Prefer street, then name when street is empty
          (place.street != null && place.street!.trim().isNotEmpty)
              ? place.street
              : (place.name != null && place.name!.trim().isNotEmpty)
              ? place.name
              : null,
          (place.subLocality != null && place.subLocality!.trim().isNotEmpty)
              ? place.subLocality
              : null,
          (place.locality != null && place.locality!.trim().isNotEmpty)
              ? place.locality
              : null,
          (place.postalCode != null && place.postalCode!.trim().isNotEmpty)
              ? place.postalCode
              : null,
          (place.country != null && place.country!.trim().isNotEmpty)
              ? place.country
              : null,
        ];
        final address = parts.whereType<String>().join(', ');

        setState(() {
          _selectedAddress = address;
          // Don't update the search controller to avoid interfering with user input
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
  }

  void _onCameraIdle() {
    if (_skipNextReverseGeocode) {
      _skipNextReverseGeocode = false;
      return;
    }
    // Get address when user stops moving the map
    _getAddressFromLatLng(_selectedLocation);
  }

  // This method is no longer needed as we handle the search result directly in the onResultSelected callback

  void _confirmLocation() {
    // Prepare the result to send back
    final result = {
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'address': _selectedAddress,
    };

    // Update the location controller with the selected location
    locationController.updateLocation(
      _selectedAddress,
      _selectedLocation.latitude,
      _selectedLocation.longitude,
    );

    // Pop and return the result to the previous screen without triggering GetX snackbar closing
    if (mounted) {
      Navigator.of(context).pop(result);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Select Location", backButton: true),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 14.0,
            ),
            myLocationEnabled: true, // Show user location
            myLocationButtonEnabled: false, // Disable default location button
            zoomControlsEnabled: false, // Hide zoom in/out buttons
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              // Ensure the map is properly positioned after creation
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(_selectedLocation, 14.0),
              );
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            // Enable all map gestures
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            // Set zoom range
            minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
            // Ensure the map is interactive
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            }.toSet(),
            // Ensure the map is properly positioned
            cameraTargetBounds: CameraTargetBounds.unbounded,
          ),

          // Center Marker (Pin Icon)
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_pin, size: 50, color: Colors.red),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _selectedAddress.split(',').take(2).join(','),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Widget (reused component)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: LocationSearchWidget(
              hintText: 'Search for a location...',
              onResultSelected: (result) {
                // Controller already fetches lat/lng in selectPrediction
                final lat = _locationController.selectedLatitude.value;
                final lng = _locationController.selectedLongitude.value;
                final address = _locationController.selectedAddress.text;

                final location = LatLng(lat, lng);
                setState(() {
                  _selectedLocation = location;
                  _selectedAddress = address;
                });
                _skipNextReverseGeocode = true;
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(location, 16),
                );
                FocusScope.of(context).unfocus();
              },
            ),
          ),

          // Search results handled inside LocationSearchWidget

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
