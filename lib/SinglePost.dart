import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  final double tailleBarreNavigation;

  // const SinglePost({Key? key}) : super(key: key);

  SinglePost({required this.tailleBarreNavigation});

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
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
            color: Color.fromARGB(255, 219, 234, 250),
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
                  child: Column(children: [
                    singlepost(
                        'https://sm.ign.com/t/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.300.jpg',
                        "Daniel",
                        'Yaoundé',
                        10,
                        20,
                        "Boulan"),
                    singlepost(
                        'https://media-mcetv.ouest-france.fr/wp-content/uploads/2023/01/avatar-ces-indices-sur-la-veritable-nature-du-personnage-de-kiri-.jpg',
                        "Daniel2",
                        'Yaoundé',
                        10,
                        20,
                        "Boulan"),
                  ]),
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Text('efe'),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//Container publication
  Widget singlepost(String avatar, String username, String userLocation,
      double typeBottle, int quantity, String meetingpoint) {
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
              backgroundImage: NetworkImage(avatar),
              radius: 30,
              child: Text(
                avatar.isEmpty ? username[0].toUpperCase() : '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userLocation,
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
                    '     ${typeBottle.toString()}',
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
                    '     ${quantity.toString()}',
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
                    '     $meetingpoint',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
//Remove or Contact
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: null,
                    child: Text(
                      "Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
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
