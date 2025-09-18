
import 'dart:async';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PickerMapScreen extends StatefulWidget {
  const PickerMapScreen({super.key});

  @override
  State<PickerMapScreen> createState() => _PickerMapScreenState();
}

class _PickerMapScreenState extends State<PickerMapScreen> {

  late GoogleMapController mapController;
  Position? _currentPosition;
  Marker? _currentLocationMarker;

  final LatLng _defaultLocation = LatLng(37.7749, -122.4194); // San Francisco


  @override
  void initState() {
    super.initState();

    getUserCurrentLocation();
  }

  Future<void> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentPosition = position;
        _currentLocationMarker = Marker(
          markerId: MarkerId("currentLocation"),
         position: LatLng(position.latitude, position.longitude),

          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "You are current Location"),
        );
      });

      mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 14));
    } catch (e) {
      print("Error getting location: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleName: "Map",
        leftIcon: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _defaultLocation,
                    zoom: 10,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _currentLocationMarker != null
                      ? {_currentLocationMarker!}
                      : Set<Marker>(),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),

           /*      Positioned.fill(
                  top: 30,
                   left: 12,
                   right: 12,
                  child: CustomTextField(
                      hintText: "search",
                      fillColor: AppColors.neutral02,
                      suffixIcon: Icon(
                        Icons.search,
                        color: AppColors.black_60,
                      )
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
