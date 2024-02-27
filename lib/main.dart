import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdsc_1_win/sign_in.dart';
import 'firebase_options.dart';
import 'package:gdsc_1_win/page_post.dart';
import 'package:gdsc_1_win/page_new_post.dart';
import 'package:gdsc_1_win/map.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SignIn(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //Current Index in BottomNavigationBar
  int indexElementBarreNavigation = 0;
  //Size of BottomNavigationBar
  double tailleBarreNavigation = 80;

  late Widget mainContent;

  @override
  void initState() {
    super.initState();
  }

//This function permit us to change the content of the page
  void navigator() {
    if (indexElementBarreNavigation == 0) {
      mainContent = const MapWidget();
    } else if (indexElementBarreNavigation == 1) {
      mainContent = const PageNewPost();
    } else if (indexElementBarreNavigation == 2) {
      mainContent = PagePost(
        tailleBarreNavigation: tailleBarreNavigation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //We load the initial content
    navigator();
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 161, 206, 243),
          child: SingleChildScrollView(
            //physics: const NeverScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [mainContent]),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: tailleBarreNavigation,
        child: BottomNavigationBar(
          items: [
            //Map
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.map_outlined,
                color: Colors.blue,
                size: 40,
              ),
              label: "Map",
            ),
            //New post
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_sharp,
                color: Colors.blue,
                size: 40,
              ),
              label: "New post",
            ),
            //List of posts
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
                color: Colors.blue,
                size: 40,
              ),
              label: 'List of posts',
            ),
            //Settings
            BottomNavigationBarItem(
                activeIcon: Column(
                  children: [
                    const Icon(
                      Icons.settings_applications,
                      color: Colors.blue,
                      size: 40,
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
                  size: 40,
                ),
                label: "Settings")
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
