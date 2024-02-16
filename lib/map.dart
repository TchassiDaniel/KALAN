import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double latitude = 37.4220936;
  double longitude = -122.085;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    getMarkers();
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future getMarkers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    List<QueryDocumentSnapshot> allPosts = querySnapshot.docs;
    for (var post in allPosts) {
      GeoPoint localisation = post["localisation"];

      markers.add(
        Marker(
            point: LatLng(localisation.latitude, localisation.longitude),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 50,
            )),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //getCurrentLocation();
    //getMarkers();
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
            ],
          ),
          MarkerLayer(markers: markers),
          FloatingActionButton(
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  getCurrentLocation();
                  getMarkers();
                  markers.add(Marker(
                      point: LatLng(latitude, longitude),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 50,
                      )));
                });
              })
        ],
      ),
    );
  }
}
