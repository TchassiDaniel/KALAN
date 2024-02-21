import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_1_win/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class OnePost extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userLocation;
  final String typeBottle;
  final int quantity;
  final String meetingPoint;
  final String userID;
  final String phoneNumber;
  final Function? reloadFunction;

  const OnePost({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userLocation,
    required this.typeBottle,
    required this.quantity,
    required this.meetingPoint,
    this.userID = "",
    required this.phoneNumber,
    this.reloadFunction,
  });

  @override
  State<OnePost> createState() => _OnePostState();
}

class _OnePostState extends State<OnePost> {
  String userID = "";

  @override
  void initState() {
    super.initState();
    loadUserID();
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

  Future<void> deletePost() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('bottle type', isEqualTo: widget.typeBottle)
          .where('quantity', isEqualTo: widget.quantity)
          .where('meetingpoint', isEqualTo: widget.meetingPoint)
          .where('UserID', isEqualTo: widget.userID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.delete();
        //showMessage(context, 'Recording Deleted Successfully!');
        if (widget.reloadFunction != null) {
          widget.reloadFunction!();
        }
      } else {
        // ignore: use_build_context_synchronously
        showMessage(context, 'Please reload application');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showMessage(context, 'Error deleting record: $e');
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

  void openPhone(BuildContext context) async {
    Uri phoneNumber = Uri.parse('tel:${widget.phoneNumber}');
    if (await launchUrl(phoneNumber)) {
      // dialer is open
    } else {
      // ignore: use_build_context_synchronously
      showMessage(context, 'Unable to open dialer');
    }
  }

  Widget removeOrContact() {
    //Remove
    if (userID == widget.userID) {
      return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red),
        ),
        onPressed: deletePost,
        child: const Text(
          "Remove",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blue),
        ),
        onPressed: () => openPhone(context),
        child: const Text(
          "Contact",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(5, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              // backgroundImage: NetworkImage(avatar),
              radius: 30,
              child: Text(
                widget.lastName[0].toUpperCase() +
                    widget.firstName[0].toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            title: Text(
              "${widget.lastName} ${widget.firstName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.userLocation,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            trailing: const Icon(
              Icons.bookmark_outline,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 80, right: 30, top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//Type of bottle
                const Text(
                  "Type of Bottle",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 148, 123, 123),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    '     ${widget.typeBottle.toString()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
//Quantity
                const Text(
                  "Quantity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 148, 123, 123),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    '     ${widget.quantity.toString()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
//meeting Point
                const Text(
                  "Meeting point",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 148, 123, 123),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 35,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    '     ${widget.meetingPoint}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
//Remove or Contact
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: removeOrContact(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
