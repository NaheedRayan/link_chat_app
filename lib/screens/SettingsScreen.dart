import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(child: Text("Logout"), onPressed: (){
                FirebaseAuth.instance.signOut();
              })
            ],
          )
      ),
    );
  }
}


