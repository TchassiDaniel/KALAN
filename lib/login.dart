import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height - 270,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: 100, bottom: 250, left: 20, right: 20),
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
                    "NEW POST",
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
