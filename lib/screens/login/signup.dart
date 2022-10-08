import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

  bool isChecked = false;

  Map<String, dynamic> data = {"name": "Bangladesh", "code": "+880"};
  Map<String, dynamic> dataResult = {"name": "Bangladesh", "code": "+880"};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('SignUp'),
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
        backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 150.0, 25.0, 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text("SignUp",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                      )),
                  const Text("For Signing Up We need Your Personal Inforamtion",
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 16)),
                  const SizedBox(
                    height: 20,
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
                    child: Text("Name",
                        style: TextStyle(color: Colors.black26, fontSize: 16)),
                  ),
                  TextField(
                      keyboardType: TextInputType.text,
                      controller: _enterUsername,
                      decoration: InputDecoration(
                        // labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),

                      style: TextStyle(
                        fontSize: 20,
                      )),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
                    child: Text("Email",
                        style: TextStyle(color: Colors.black26, fontSize: 16)),
                  ),

                  TextField(
                      keyboardType: TextInputType.text,
                      controller: _enterEmail,
                      decoration: InputDecoration(
                        // labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),

                      style: TextStyle(
                        fontSize: 20,
                      )),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
                    child: Text("Phone Number",
                        style: TextStyle(color: Colors.black26, fontSize: 16)),
                  ),
                  IntlPhoneField(
                      keyboardType: TextInputType.number,
                      controller: _enterPhoneNumber,
                      decoration: InputDecoration(
                        // labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'BD',
                      style: TextStyle(
                        fontSize: 20,
                      )),

                  Row(
                    children: [
                      Checkbox(value: isChecked, onChanged: (bool? value){
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                      Expanded(child: Text("I have read and agree to the Privacy Policy and Terms and Condition"))
                    ],
                  ),

                  //-----------------------------------------------------------


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          child: Text("Sign Up"),
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
                      ],
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
