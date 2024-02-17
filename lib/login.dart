import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = "";
  String lastName = "";
  String username = "";
  String password = "";
  String email = "";
  String location = "";

  //clé de formulaire
  final _formKey = GlobalKey<FormState>();

  void validationForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> data = {
        'First_name': name,
        'Last_name': lastName,
        'Password': password,
        "Usename": username,
        "Email": email,
        "Location": location,
      };

      await FirebaseFirestore.instance.collection('users').add(data);

      _formKey.currentState!.reset();
    }
  }

  Future<bool> checkUsername(String username) async {
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isEmpty) {
      //print('Le nom d\'utilisateur n\'est pas déjà utilisé.');
      return false;
    } else {
      //print('Le nom d\'utilisateur est déjà utilisé.');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: 10, bottom: 250, left: 20, right: 20),
      child: Column(
        children: [
//Entête avec logo
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
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
          //formulaire de connection
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  //First Name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "FirstName",
                      hintText: "Enter your first name",
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    onSaved: (val) => name = val.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Enter your first name" : null,
                  ),
                  //Last Name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Last name",
                      hintText: "Enter your last name",
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    onSaved: (val) => lastName = val.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Enter your last name" : null,
                  ),
                  //Email
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your Email",
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    onSaved: (val) => email = val.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Enter your Email" : null,
                  ),

                  //Location
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "city",
                      hintText: "Enter your city",
                      icon: Icon(
                        Icons.location_city_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    onSaved: (val) => location = val.toString(),
                    validator: (val) => val!.isEmpty ? "Enter your city" : null,
                  ),

                  //Username
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: "UserName",
                        hintText: "Enter your Username",
                        icon: Icon(
                          Icons.lock_person,
                          color: Colors.blue,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      onSaved: (val) => username = val.toString(),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your Usermane";
                        } else if (checkUsername(val) == true) {
                          return "Username is already use";
                        } else {
                          return null;
                        }
                      }),
                  //Password
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      icon: Icon(
                        Icons.password,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autofocus: true,
                    onChanged: (val) => password = val,
                    onSaved: (val) => password = val.toString(),
                    validator: (val) =>
                        val!.isEmpty ? "Enter your password" : null,
                  ),
                  //Confirm Password
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Confirm password",
                      hintText: "Confirm your password",
                      icon: Icon(
                        Icons.password,
                        color: Colors.blue,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    autofocus: true,
                    onSaved: (val) => password = val.toString(),
                    validator: (val) =>
                        val != password ? "Password doesn't match" : null,
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: validationForm,
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
