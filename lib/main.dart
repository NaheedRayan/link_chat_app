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
import 'package:link_chat_app/screens/login/user_name.dart';
import 'package:link_chat_app/screens/login/verify_number.dart';
import 'package:link_chat_app/screens/people.dart';
import 'package:link_chat_app/screens/login/hello.dart';

import 'screens/login/edit_number.dart';

//
// void main() {
//   runApp(const MyApp());
// }

const bool USE_EMULATOR = false;
bool loggedin = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ? CupertinoApp(
            home: HomePage(), //got to main home page
            theme: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Color(0xFF08C187),
            ),
            debugShowCheckedModeBanner: false,
          )
        : CupertinoApp(
            home: Hello(), //start from hello page
            theme: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Color(0xFF08C187),
            ),
            debugShowCheckedModeBanner: false,
          );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var screens = [Chats(), Calls(), People(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              label: "Chats", icon: Icon(CupertinoIcons.chat_bubble_fill)),
          BottomNavigationBarItem(
              label: "Call", icon: Icon(CupertinoIcons.phone)),
          BottomNavigationBarItem(
              label: "People", icon: Icon(CupertinoIcons.person_alt_circle)),
          BottomNavigationBarItem(
              label: "Settings", icon: Icon(CupertinoIcons.settings_solid)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return screens[index];
      },
    ));
  }
}
