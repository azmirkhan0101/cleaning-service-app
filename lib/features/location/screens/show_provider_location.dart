import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowProviderLocation extends StatefulWidget {
  const ShowProviderLocation({super.key, required this.providerLatLng});

  final LatLng providerLatLng;

  @override
  State<ShowProviderLocation> createState() => _ShowProviderLocationState();
}

class _ShowProviderLocationState extends State<ShowProviderLocation> {
  ProfileController profileController = Get.put(ProfileController());
  LatLng? ownerLatLng;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    ownerLatLng = LatLng(
      profileController.profile.value?.latitude ?? 0.0,
      profileController.profile.value?.longitude ?? 0.0,
    );
    print("Owner lat: ${ownerLatLng?.latitude}");
    print("Owner long: ${ownerLatLng?.longitude}");
    _createMarkers();
  }

  void _createMarkers() {
    _markers = {
      // Provider marker (blue)
      Marker(
        markerId: MarkerId('provider'),
        position: widget.providerLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: 'Provider Location',
          snippet: 'Service provider is here',
        ),
      ),
      // Owner marker (red)
      if (ownerLatLng != null)
        Marker(
          markerId: MarkerId('owner'),
          position: ownerLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
        ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitBoundsToShowBothMarkers();
  }

  void _fitBoundsToShowBothMarkers() {
    if (_mapController == null || ownerLatLng == null) return;

    // Calculate bounds to show both markers
    double southWestLat = widget.providerLatLng.latitude < ownerLatLng!.latitude
        ? widget.providerLatLng.latitude
        : ownerLatLng!.latitude;
    double southWestLng =
        widget.providerLatLng.longitude < ownerLatLng!.longitude
        ? widget.providerLatLng.longitude
        : ownerLatLng!.longitude;

    double northEastLat = widget.providerLatLng.latitude > ownerLatLng!.latitude
        ? widget.providerLatLng.latitude
        : ownerLatLng!.latitude;
    double northEastLng =
        widget.providerLatLng.longitude > ownerLatLng!.longitude
        ? widget.providerLatLng.longitude
        : ownerLatLng!.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // 100 is padding
    );
  }

  String _getDistanceText() {
    if (ownerLatLng == null) return 'Provider Location';

    double distanceInMeters = Geolocator.distanceBetween(
      widget.providerLatLng.latitude,
      widget.providerLatLng.longitude,
      ownerLatLng!.latitude,
      ownerLatLng!.longitude,
    );

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m away';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km away';
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getDistanceText()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ownerLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.providerLatLng,
                    zoom: 12,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: true,
                ),

                // two markers legend
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Provider Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Your Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
