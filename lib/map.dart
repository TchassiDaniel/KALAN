import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double latitude = 37.4220936;
  double longitude = -122.085;
  List<Marker> markers = [];
  List<LatLng> routeCoordinates = [];

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
          child: IconButton(
              icon: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 50,
              ),
              onPressed: () {
                getCurrentLocation();
                getRouteCoordinates(
                    LatLng(localisation.latitude, localisation.longitude));
              }),
        ),
      );
    }
    setState(() {});
  }

  Future<void> getRouteCoordinates(LatLng end) async {
    final response = await http.get(Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$longitude,$latitude;${end.longitude},${end.latitude}?geometries=geojson'));
    if (response.statusCode == 200) {
      debugPrint("Hef");
      final result = json.decode(response.body);
      List<dynamic> coordinates =
          result['routes'][0]['geometry']['coordinates'];
      setState(() {
        routeCoordinates = coordinates.map((c) => LatLng(c[1], c[0])).toList();
      });
    } else {
      throw Exception('Failed to fetch route coordinates');
    }
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
              }),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routeCoordinates,
                color: Colors.blue,
                strokeWidth: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
