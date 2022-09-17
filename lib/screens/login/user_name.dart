import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_chat_app/main.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  var _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Text("Enter Your name"),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CupertinoTextField(
            controller: _text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
            maxLength: 15,
            keyboardType: TextInputType.name,
            autofillHints: <String>[AutofillHints.name],
          ),
        ),
        CupertinoButton.filled(
            child: Text("Continue"),
            onPressed: () async {
              // await FirebaseAuth.instance.currentUser
              //     ?.updateProfile(displayName: _text.text);

              // await FirebaseAuth.instance.currentUser?.updateDisplayName(_text.text) ;

              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage()), (route) => false);
              Fluttertoast.showToast(
                  msg: "Welcome",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            })
      ],
    ));
  }
}
