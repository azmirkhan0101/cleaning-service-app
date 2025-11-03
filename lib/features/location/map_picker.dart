import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
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

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LocationController _locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
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
    // Get address when user stops moving the map
    _getAddressFromLatLng(_selectedLocation);
    
    // Update the map controller's position to ensure smooth movement
    mapController.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  // This method is no longer needed as we handle the search result directly in the onResultSelected callback

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
      appBar: CustomAppBar(titleName: "Select Location", leftIcon: true),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _selectedAddress.split(',').take(2).join(','),
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Widget
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search for a location...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _locationController.clearSearchResults();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  _locationController.searchLocations(value);
                },
              ),
            ),
          ),

          // Search results
          Obx(() => _locationController.showSearchResults.value &&
                  _locationController.searchResults.isNotEmpty
              ? Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _locationController.searchResults.length,
                      itemBuilder: (context, index) {
                        final result =
                            _locationController.searchResults[index];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.blue),
                          title: Text(result['main_text'] ?? 'Unknown location'),
                          subtitle: Text(result['secondary_text'] ?? ''),
                          onTap: () {
                            final location = LatLng(
                              result['latitude'],
                              result['longitude'],
                            );
                            setState(() {
                              _selectedLocation = location;
                              _selectedAddress = result['address'];
                              _searchController.text = result['address'];
                            });
                            mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(location, 16),
                            );
                            _locationController.clearSearchResults();
                            _searchFocusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
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
