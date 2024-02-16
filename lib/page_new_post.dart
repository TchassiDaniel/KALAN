import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class PageNewPost extends StatefulWidget {
  const PageNewPost({super.key});

  @override
  State<PageNewPost> createState() => _PageNewPostState();
}

class _PageNewPostState extends State<PageNewPost> {
  String? typeBottle;
  String? localisation;
  int? quantite;
  String? meetingPoint;
  late Position currentPosition;

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  void validationForm() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      GeoPoint location =
          GeoPoint(currentPosition.latitude, currentPosition.longitude);
      Map<String, dynamic> data = {
        'bottle type': typeBottle,
        'quantity': quantite,
        'localisation': location,
        "meetingpoint": meetingPoint,
      };

      await FirebaseFirestore.instance.collection('posts').add(data);

      formkey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Container(
        height: MediaQuery.sizeOf(context).height - 270,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        margin:
            const EdgeInsets.only(top: 100, bottom: 250, left: 20, right: 20),
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
                children: [
                  //Localisation
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
                      Expanded(
                        child: DropdownButtonFormField(
                            validator: (value) => value!.isEmpty
                                ? "Validez votre position"
                                : null,
                            onSaved: (newValue) => localisation = newValue,
                            value: localisation,
                            hint: const Text("Entrez votre position"),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            items: const [
                              DropdownMenuItem(
                                value: "My position",
                                child: Text("My position"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                localisation = value.toString();
                                getCurrentLocation();
                              });
                            }),
                      )
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
                      Expanded(
                        child: DropdownButtonFormField(
                            validator: (value) => value!.isEmpty
                                ? "Validate your bottle type"
                                : null,
                            onSaved: (newValue) => typeBottle = newValue,
                            value: typeBottle,
                            hint: const Text("Entrez Le type de bouteille"),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
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
                            }),
                      )
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
                      Expanded(
                        child: DropdownButtonFormField(
                            validator: (value) =>
                                value == 0 ? "Validate your quantity" : null,
                            onSaved: (newValue) => quantite = newValue,
                            value: quantite,
                            hint: const Text("quantité de bouteille:"),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            items: List.generate(1000, (index) => index + 1)
                                .map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                debugPrint("Hello");
                                quantite = value == null ? 0 : value.toInt();
                              });
                            }),
                      )
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
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Validate your meeting point" : null,
                      onSaved: (newValue) => meetingPoint = newValue,
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
                                onPressed: validationForm,
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
                              setState(() {
                                formkey.currentState!.reset();
                              });
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
      ),
    );
  }
}
