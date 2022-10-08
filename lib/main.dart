import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_chat_app/screens/SettingsScreen.dart';
import 'package:link_chat_app/screens/calls.dart';
import 'package:link_chat_app/screens/chats.dart';
import 'package:link_chat_app/screens/login/verify_number.dart';
import 'package:link_chat_app/screens/people.dart';
import 'package:link_chat_app/screens/login/hello.dart';
import 'package:flutter/services.dart';

import 'screens/login/edit_number.dart';

//
// void main() {
//   runApp(const MyApp());
// }

const bool USE_EMULATOR = false;
bool loggedin = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //for transparent status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  await Firebase.initializeApp();

  if (USE_EMULATOR) {
    _connectToFirebaseEmulator();
  }

  //getting status of user in the initial stage of app
  await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      print('User is signed in!');
      loggedin = true;
    } else {
      print('User is currently signed out!');
      loggedin = false;
    }
  });
  runApp(const MyApp());
}

Future _connectToFirebaseEmulator() async {
  final fireStorePort = "8080";
  final authPort = 9099;
  final storagePort = 9199;
  final localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  // String host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';

  FirebaseFirestore.instance.settings = Settings(
      host: "$localHost:$fireStorePort",
      // host: host,
      sslEnabled: false,
      persistenceEnabled: false);

  await FirebaseAuth.instance.useAuthEmulator(localHost, authPort);
  await FirebaseStorage.instance.useStorageEmulator(localHost, storagePort);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (loggedin == true)
        ? MaterialApp(
            home: HomePage(), //got to main home page
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Color(0xFF08C187),
            ),
            // theme: CupertinoThemeData(
            //   brightness: Brightness.light,
            //   primaryColor: Color(0xFF08C187),
            // ),
            debugShowCheckedModeBanner: false,
          )
        : MaterialApp(
            home: Hello(), //start from hello page
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Color(0xFF08C187),
            ),
            // theme: CupertinoThemeData(
            //   brightness: Brightness.light,
            //   primaryColor: Color(0xFF08C187),
            // ),
            debugShowCheckedModeBanner: false,
          );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screens = [Chats(), Calls(), People(), SettingsScreen()];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Well hello"),
      // ),
      body: Center(
        // child: _widgetOptions.elementAt(_selectedIndex),
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //for more than 3 items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_front),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],

        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );

  }
}
