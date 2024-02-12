import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:gdsc_1_win/single_post.dart';
import 'package:gdsc_1_win/page_new_post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int indexElementBarreNavigation = 1;

  double tailleBarreNavigation = 100;

  late Widget mainContent;

  @override
  void initState() {
    super.initState();
  }

//Gestionnaire de passage entre écran
  void navigator() {
    if (indexElementBarreNavigation == 1) {
      mainContent = PageNewPost();
    } else if (indexElementBarreNavigation == 2) {
      mainContent = SinglePost(
        tailleBarreNavigation: tailleBarreNavigation,
      );
    }
  }

// //Container d'ajout d'élément
//   Container pageNewPost() {
//     String? typeBottle;
//     String? localisation;
//     num? quantite;
//     String? meetingPoint;

//     return Container(
//       height: MediaQuery.sizeOf(context).height - 270,
//       width: MediaQuery.sizeOf(context).width,
//       decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           color: Colors.white),
//       margin: const EdgeInsets.only(top: 100, bottom: 250, left: 20, right: 20),
//       child: Column(
//         children: [
// //Entete new post
//           Container(
//             width: MediaQuery.sizeOf(context).width,
//             height: 100,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               color: Colors.blue,
//             ),
//             child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     "NEW POST",
//                     style: TextStyle(
//                         color: Colors.white,
//                         backgroundColor: Colors.blueAccent,
//                         fontSize: 30),
//                     textAlign: TextAlign.center,
//                   ),
//                 ]),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
// //Localisation
//               children: [
//                 const Text(
//                   "Location",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 148, 123, 123)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Row(children: [
//                     const Icon(
//                       Icons.circle_outlined,
//                       color: Colors.blue,
//                       size: 50,
//                     ),
//                     DropdownButton(
//                         value: localisation,
//                         hint: const Text("Entrez votre position"),
//                         items: const [
//                           DropdownMenuItem(
//                             value: "Ma position",
//                             child: Text("Ma position"),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             localisation = value;
//                           });
//                         })
//                   ]),
//                 ),
// //Type of bottle
//                 const Text(
//                   "Type of Bottle",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 148, 123, 123)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Row(children: [
//                     const Icon(
//                       Icons.circle_outlined,
//                       color: Colors.blue,
//                       size: 50,
//                     ),
//                     DropdownButton(
//                         value: typeBottle,
//                         hint: const Text("Entrez Le type de bouteille"),
//                         items: const <DropdownMenuItem<String>>[
//                           DropdownMenuItem(
//                             value: "Plastic",
//                             child: Text("Plastic"),
//                           ),
//                           DropdownMenuItem(
//                             value: "Glass",
//                             child: Text("Glass"),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             typeBottle = value;
//                           });
//                         })
//                   ]),
//                 ),
// //Quantité
//                 const Text(
//                   "Quantity",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 148, 123, 123)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Row(children: [
//                     const Icon(
//                       Icons.circle_outlined,
//                       color: Colors.blue,
//                       size: 50,
//                     ),
//                     DropdownButton(
//                         value: quantite,
//                         hint: const Text("quantité de bouteille:"),
//                         items: const <DropdownMenuItem<int>>[
//                           DropdownMenuItem(value: 10, child: Text("10")),
//                           DropdownMenuItem(value: 20, child: Text("20")),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             quantite = value;
//                           });
//                         })
//                   ]),
//                 ),
// //Point de rencontre
//                 const Text(
//                   'Meeting point',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Color.fromARGB(255, 148, 123, 123)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       icon: Icon(
//                         Icons.circle_outlined,
//                         color: Colors.blue,
//                         size: 50,
//                       ),
//                       border: InputBorder.none,
//                       hintText: "Enter the meeting point",
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         meetingPoint = value;
//                       });
//                     },
//                   ),
//                 ),

//                 Container(
//                   alignment: Alignment.center,
//                   margin: const EdgeInsets.only(top: 60),
// //Validate
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               style: const ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStatePropertyAll(Colors.blue)),
//                               onPressed: () async {
//                                 Map<String, dynamic> data = {
//                                   'bottle type': typeBottle,
//                                   'quantity': quantite,
//                                   'localisation': localisation,
//                                   "meetingpoint": meetingPoint,
//                                 };

//                                 await FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .add(data);
//                               },
//                               child: const Text(
//                                 "Validate",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
// //Cancel
//                       ElevatedButton(
//                           style: const ButtonStyle(
//                               backgroundColor:
//                                   MaterialStatePropertyAll(Colors.white)),
//                           onPressed: () {
//                             setState(() {});
//                           },
//                           child: const Text("Cancel")),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// //Container de la page Des posts effectués
//   Container pagePost() {
//     double hauteurTab = 50;
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             height: hauteurTab,
//             child: TabBar(
//               controller: _controller,
//               tabs: const [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Public Feed",
//                       style:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "My Feed",
//                       style:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: const Color.fromARGB(255, 207, 225, 240),
//             height: MediaQuery.sizeOf(context).height -
//                 tailleBarreNavigation -
//                 hauteurTab -
//                 25,
//             width: MediaQuery.sizeOf(context).width,
//             child: TabBarView(
//               controller: _controller,
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(children: [
//                     singlepost(
//                         'https://sm.ign.com/t/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.300.jpg',
//                         "Daniel",
//                         'Yaoundé',
//                         10,
//                         20,
//                         "Boulan"),
//                     singlepost(
//                         'https://media-mcetv.ouest-france.fr/wp-content/uploads/2023/01/avatar-ces-indices-sur-la-veritable-nature-du-personnage-de-kiri-.jpg',
//                         "Daniel2",
//                         'Yaoundé',
//                         10,
//                         20,
//                         "Boulan"),
//                   ]),
//                 ),
//                 const SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(children: [
//                     Text('efe'),
//                   ]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// //Container publication
//   Widget singlepost(String avatar, String username, String userLocation,
//       double typeBottle, int quantity, String meetingpoint) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20), color: Colors.white),
//       margin: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.indigo,
//               foregroundColor: Colors.white,
//               backgroundImage: NetworkImage(avatar),
//               radius: 30,
//               child: Text(
//                 avatar.isEmpty ? username[0].toUpperCase() : '',
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//               ),
//             ),
//             title: Text(
//               username,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               userLocation,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, color: Colors.blue),
//             ),
//             trailing: const Icon(
//               Icons.bookmark_outline,
//               color: Colors.blue,
//               size: 30,
//             ),
//           ),
//           Container(
//             margin:
//                 const EdgeInsets.only(left: 80, right: 30, top: 10, bottom: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
// //Type of bottle
//                 const Text(
//                   "Type of Bottle",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 148, 123, 123),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.sizeOf(context).width,
//                   height: 35,
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Text(
//                     '     ${typeBottle.toString()}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
// //Quantity
//                 const Text(
//                   "Quantity",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 148, 123, 123),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.sizeOf(context).width,
//                   height: 35,
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Text(
//                     '     ${quantity.toString()}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
// //meeting Point
//                 const Text(
//                   "Meeting point",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 148, 123, 123),
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.sizeOf(context).width,
//                   height: 35,
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     color: Colors.grey[350],
//                   ),
//                   child: Text(
//                     '     $meetingpoint',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
// //Remove or Contact
//                 const Padding(
//                   padding: EdgeInsets.only(top: 30),
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStatePropertyAll(Colors.blue),
//                     ),
//                     onPressed: null,
//                     child: Text(
//                       "Contact",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    navigator();
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 161, 206, 243),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: mainContent,
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: tailleBarreNavigation,
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.map_outlined,
                color: Colors.blue,
                size: 60,
              ),
              label: "Map",
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_sharp,
                color: Colors.blue,
                size: 60,
              ),
              label: "Nouveau post",
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
                color: Colors.blue,
                size: 60,
              ),
              label: 'Liste des posts',
            ),
            BottomNavigationBarItem(
                activeIcon: Column(
                  children: [
                    const Icon(
                      Icons.settings_applications,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Container(
                      height: 4,
                      width: 20,
                      color: Colors.blue,
                    )
                  ],
                ),
                icon: const Icon(
                  Icons.settings_applications,
                  color: Colors.blue,
                  size: 60,
                ),
                label: "Paramètre")
          ],
          currentIndex: indexElementBarreNavigation,
          onTap: (int id) {
            setState(() {
              indexElementBarreNavigation = id;
              navigator();
            });
          },
        ),
      ),
    );
  }
}

// class CustomTabcontroller extends TabController{
  
//   CustomTabcontroller({int initialIndex = 0, @required int lenght}):
//   super(initialIndex: initialIndex, length: lenght);

//   @override
//   void dispose(){

//   }
// }