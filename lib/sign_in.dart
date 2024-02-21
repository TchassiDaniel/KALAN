import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_1_win/login.dart';
import 'package:gdsc_1_win/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String username = "";
  String password = "";

  //clé de formulaire
  final _formKey = GlobalKey<FormState>();

  void saveUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserID', id);
  }

  void validationForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      verifyUserAndPassword(username, password).then((value) {
        if (value == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          showMessage(context, 'Wrong username or password');
        }
      });
    }
  }

  Future<bool> verifyUserAndPassword(String username, String password) async {
    bool isValid = false;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<QueryDocumentSnapshot> allPosts = querySnapshot.docs;
    for (var doc in allPosts) {
      if (doc['Username'] == username && doc['Password'] == password) {
        isValid = true;
        //Enregistrement de l'id de l'enrefistrement de l'utilisateur dans firebase
        saveUserID(doc.id);
      }
    }
    return isValid;
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
                color: Colors.red, fontSize: 50, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            margin: const EdgeInsets.only(
                top: 100, bottom: 400, left: 20, right: 20),
            child: Column(children: [
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
                        "SIGN IN",
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
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
                      validator: (val) =>
                          val!.isEmpty ? "Enter your password" : null,
                    ),
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
                    const Padding(padding: EdgeInsets.all(20)),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          "i don't have an account",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ]),
                ),
              ),
            ])),
      ),
    );
  }
}
