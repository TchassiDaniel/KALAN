import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_1_win/login.dart';
import 'package:gdsc_1_win/one_post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PagePost extends StatefulWidget {
  final double tailleBarreNavigation;

  // const PagePost({Key? key}) : super(key: key);

  const PagePost({super.key, required this.tailleBarreNavigation});

  @override
  State<PagePost> createState() => _PagePostState();
}

class _PagePostState extends State<PagePost> with TickerProviderStateMixin {
  late TabController _controller;
  List<Widget> listPosts = [];
  List<Widget> listPostsUserAndFavorite = [];

  String userID = "";
  //On enregistre la les donnees de la base de donnée
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    //Loading of all required data to be displayed
    loadUserID();
    getAllPosts();
  }

  Future<void> loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('UserID') ?? "";
    });

    if (userID == "") {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<List<String>> getUserIdentity(String userID) async {
    String firstName = '';
    String lastName = '';
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (document.exists) {
      firstName = document['First_name'];
      lastName = document['Last_name'];
    }
    return [firstName, lastName];
  }

  Future<void> getAllPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('Timetamp', descending: true)
        .get();
    List<QueryDocumentSnapshot> allPosts = querySnapshot.docs;

    for (var post in allPosts) {
      // Utilisez les données comme vous le souhaitez, par exemple, en les envoyant à la fonction PagePost
      //On récupère les donnée de localisation
      GeoPoint localisation = post["localisation"];
      String pos;
      //Recupération des lieux approximatifs
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${localisation.latitude}&lon=${localisation.longitude}'),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        pos = result['display_name'];
      } else {
        throw Exception('Failed to fetch place name');
      }
      //On recupere le nom et prenom de l'utilisateur
      String userIDPost = post['UserID'];


      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userIDPost)
          .get();

      Widget apost = OnePost(
        firstName: document['First_name'],
        lastName: document['Last_name'],
        userLocation: pos,
        typeBottle: post['bottle type'],
        quantity: post['quantity'],
        meetingPoint: post["meetingpoint"],
        userID: userIDPost,
        phoneNumber: document['Phone_number'],
        reloadFunction: reload,
      );
      listPosts.add(apost);

      if (post["UserID"] == userID) {
        listPostsUserAndFavorite.add(apost);
      }
    }
    setState(() {
      //Mise à jour de l'affichage
    });
  }

//On va recharger le container en cas de suppression d'élément surtout
  void reload() {
    listPosts.clear();
    listPostsUserAndFavorite.clear();
    getAllPosts();
  }

//Container de la page Des posts effectués
  Container pagePost() {
    double hauteurTab = 50;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: hauteurTab,
            child: TabBar(
              controller: _controller,
              tabs: const [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Public Feed",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Feed",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 219, 234, 250),
            height: MediaQuery.sizeOf(context).height -
                widget.tailleBarreNavigation -
                hauteurTab -
                25,
            width: MediaQuery.sizeOf(context).width,
            child: TabBarView(
              controller: _controller,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: listPosts),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: listPostsUserAndFavorite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pagePost();
  }
}
