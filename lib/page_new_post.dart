import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageNewPost extends StatefulWidget {
  @override
  _PageNewPostState createState() => _PageNewPostState();
}

class _PageNewPostState extends State<PageNewPost> {
  String? typeBottle;
  String? localisation;
  int? quantite;
  String? meetingPoint;

  //Container d'ajout d'élément

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height - 270,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white),
      margin: const EdgeInsets.only(top: 100, bottom: 250, left: 20, right: 20),
      child: Column(
        children: [
//Entete new post
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.blue,
            ),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "NEW POST",
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
//Localisation
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 148, 123, 123)),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Row(children: [
                    const Icon(
                      Icons.circle_outlined,
                      color: Colors.blue,
                      size: 50,
                    ),
                    DropdownButton(
                        value: localisation,
                        hint: const Text("Entrez votre position"),
                        items: const [
                          DropdownMenuItem(
                            value: "Ma position",
                            child: Text("Ma position"),
                          ),
                          DropdownMenuItem(
                            value: "Ma position1",
                            child: Text("Ma position1"),
                          ),
                          DropdownMenuItem(
                            value: "Ma positionA",
                            child: Text("Ma positionA"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            localisation = value.toString();
                          });
                        })
                  ]),
                ),
//Type of bottle
                const Text(
                  "Type of Bottle",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 148, 123, 123)),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Row(children: [
                    const Icon(
                      Icons.circle_outlined,
                      color: Colors.blue,
                      size: 50,
                    ),
                    DropdownButton(
                        value: typeBottle,
                        hint: const Text("Entrez Le type de bouteille"),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: "Plastic",
                            child: Text("Plastic"),
                          ),
                          DropdownMenuItem(
                            value: "Glass",
                            child: Text("Glass"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            typeBottle = value.toString();
                          });
                        })
                  ]),
                ),
//Quantité
                const Text(
                  "Quantity",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 148, 123, 123)),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Row(children: [
                    const Icon(
                      Icons.circle_outlined,
                      color: Colors.blue,
                      size: 50,
                    ),
                    DropdownButton(
                        value: quantite,
                        hint: const Text("quantité de bouteille:"),
                        items: const <DropdownMenuItem<int>>[
                          DropdownMenuItem(value: 10, child: Text("10")),
                          DropdownMenuItem(value: 20, child: Text("20")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            debugPrint("Hello");
                            quantite = value == null ? 0 : value.toInt();
                          });
                        })
                  ]),
                ),
//Point de rencontre
                const Text(
                  'Meeting point',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 148, 123, 123)),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.circle_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                      border: InputBorder.none,
                      hintText: "Enter the meeting point",
                    ),
                    onChanged: (value) {
                      setState(() {
                        meetingPoint = value;
                      });
                    },
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 60),
//Validate
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () async {
                                Map<String, dynamic> data = {
                                  'bottle type': typeBottle,
                                  'quantity': quantite,
                                  'localisation': localisation,
                                  "meetingpoint": meetingPoint,
                                };

                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .add(data);
                              },
                              child: const Text(
                                "Validate",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
//Cancel
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Cancel")),
                    ],
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