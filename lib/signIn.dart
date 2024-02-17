import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void validationForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool is_user;
      verifyUserAndPassword(username, password)
          .then((value) => value == true ? is_user = true : is_user = false);
    }
  }

  Future<bool> verifyUserAndPassword(String username, String password) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Username', isEqualTo: username)
        .where('Password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Les informations de connexion sont valides
      return true;
    } else {
      // Les informations de connexion sont invalides
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        margin:
            const EdgeInsets.only(top: 100, bottom: 250, left: 20, right: 20),
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
              ]),
            ),
          )
        ]));
  }
}
