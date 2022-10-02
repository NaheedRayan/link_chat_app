import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_chat_app/screens/login/edit_number.dart';
import 'package:link_chat_app/screens/login/select_country.dart';
import 'package:link_chat_app/screens/login/verify_number.dart';

import '../../components/logo.dart';
import '../../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _enterPhoneNumber = TextEditingController();
  var _enterUsername = TextEditingController();
  var _enterEmail = TextEditingController();

  Map<String, dynamic> data = {"name": "Bangladesh", "code": "+880"};
  Map<String, dynamic> dataResult = {"name": "Bangladesh", "code": "+880"};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('SignUp'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Logo(width: 50.0, height: 50.0, radius: 25.0),
                      Text("SignUp",
                          style: TextStyle(
                              color: Color(0xFF08C187).withOpacity(0.7),
                              fontSize: 30))
                    ],
                  ),
                  Text("Enter your phone number",
                      style: TextStyle(
                          color: CupertinoColors.systemGrey.withOpacity(0.7),
                          fontSize: 25)),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () async {
                      dataResult = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SelectCountry()));
                      setState(() {
                        if (dataResult != null) data = dataResult;
                      });
                    },
                    title: Text(data["name"],
                        style:
                            TextStyle(color: Color(0xFF08C187), fontSize: 25)),
                  ),

                  Divider(
                      height: 1, color: Colors.grey, endIndent: 16, indent: 16),
                  // THIS
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: Text(data["code"],
                              style: TextStyle(
                                  fontSize: 25,
                                  color: CupertinoColors.secondaryLabel)),
                        ),
                        Expanded(
                          child: CupertinoTextField(
                            placeholder: "Enter your phone number",
                            controller: _enterPhoneNumber,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25,
                                color: CupertinoColors.secondaryLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: CupertinoTextField(
                      placeholder: "Username",
                      controller: _enterUsername,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontSize: 25, color: CupertinoColors.secondaryLabel),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: CupertinoTextField(
                      placeholder: "Email",
                      controller: _enterEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: 25, color: CupertinoColors.secondaryLabel),
                    ),
                  ),
                  Text("You will receive an activation code in short time",
                      style: TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 15)),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: ElevatedButton(
                      child: Text("Request code"),
                      onPressed: () async {
                        print("The button is pressed");
                        if (await checkIfDocExists(data['code']! + _enterPhoneNumber.text.trim()) == true) {

                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => VerifyNumber(
                                        number: data['code']! +
                                            _enterPhoneNumber.text.trim(),
                                        username: _enterUsername.text.trim(),
                                        email: _enterEmail.text.trim(),
                                        page_name: "signup",
                                      )));
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please wait for the OTP code")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("User Exists")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          textStyle: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

/// Check If Document Exists
Future<bool> checkIfDocExists(String docId) async {
  try {
    // Get reference to Firestore collection
    var document =
        await FirebaseFirestore.instance.collection('user').doc(docId).get();
    if (!document.exists) {
      return true;
    }else
      return false;
  } catch (e) {
    throw e;
  }
}
