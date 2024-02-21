import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gdsc_1_win/one_post.dart';
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
  double latitude = 3.8606467;
  double longitude = 11.5484633;
  List<Marker> markers = [];
  List<LatLng> routeCoordinates = [];
  late MapController _mapController;

  //Information
  bool showInformation = false;
  String firstName = "";
  String lastName = "";
  String userLocation = "";
  String typeBottle = "";
  int quantity = 0;
  String meetingPoint = "";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();

    _mapController = MapController();

    getMarkers();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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
                size: 60,
              ),
              onPressed: () async {
                getCurrentLocation();
                getRouteCoordinates(
                    LatLng(localisation.latitude, localisation.longitude),
                    context);
                ////////////////

                // Utilisez les données comme vous le souhaitez, par exemple, en les envoyant à la fonction SinglePost
                //Recupération des lieux approximatifs
                final response = await http.get(
                  Uri.parse(
                      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${localisation.latitude}&lon=${localisation.longitude}'),
                );
                if (response.statusCode == 200) {
                  final result = json.decode(response.body);
                  userLocation = result['display_name'];
                } else {
                  throw Exception('Failed to fetch place name');
                }
                //On recupere le nom et prenom de l'utilisateur
                String userID = post['UserID'];
                DocumentSnapshot document = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .get();

                firstName = document['First_name'];
                lastName = document['Last_name'];
                typeBottle = post['bottle type'];
                quantity = post['quantity'];
                meetingPoint = post["meetingpoint"];
                phoneNumber = document['Phone_number'];
                showInformation = true;
                setState(() {
                  //////////////
                });
              }),
        ),
      );
    }
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 60, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(fontSize: 30)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getRouteCoordinates(LatLng end, BuildContext context) async {
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
      // ignore: use_build_context_synchronously
      showMessage(context, 'Can not find a way');
    }
  }

  @override
  Widget build(BuildContext context) {
    //getCurrentLocation();
    //getMarkers();
    return Stack(children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: FlutterMap(
          mapController: _mapController,
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
                TextSourceAttribution('OpenStreetMap contributors',
                    onTap: () {}),
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
                    markers.clear;
                    getMarkers();
                    markers.add(Marker(
                        point: LatLng(latitude, longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 50,
                        )));
                    _mapController.move(LatLng(latitude, longitude), 17);
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
      ),
      Visibility(
        visible: showInformation,
        child: Column(
          children: [
            OnePost(
                firstName: firstName,
                lastName: lastName,
                userLocation: userLocation,
                typeBottle: typeBottle,
                quantity: quantity,
                meetingPoint: meetingPoint,
                phoneNumber: phoneNumber),
            TextButton(
              onPressed: () => {
                setState(() {
                  showInformation = false;
                })
              },
              child: const Text(
                "Close",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 50),
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
