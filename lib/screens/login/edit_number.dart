import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:link_chat_app/components/logo.dart';
import 'package:link_chat_app/screens/login/select_country.dart';
import 'package:link_chat_app/screens/login/signup.dart';

import 'verify_number.dart';

class EditNumber extends StatefulWidget {
  const EditNumber({Key? key}) : super(key: key);

  @override
  State<EditNumber> createState() => _EditNumberState();
}

class _EditNumberState extends State<EditNumber> {
  var _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "Bangladesh", "code": "+880"};
  Map<String, dynamic> dataResult = {"name": "Bangladesh", "code": "+880"};

  // Map<String ,dynamic> dataResult;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(

          // appBar: AppBar(
          //   title: const Text('Sign In'),
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Link",
                    style: TextStyle(color: Color(0xFF08C187), fontSize: 60)),
                Text("Privacy Matters",
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 20)),
                SizedBox(
                  height: 50,
                ),
                Text("Sign In",
                    style: TextStyle(color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold,)),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
                  child: Text("Your Phone Number",
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

                // Text("You will receive an activation code in short time",
                //     style: TextStyle(
                //         color: CupertinoColors.systemGrey, fontSize: 15)),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        child: Text("Sign In"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => VerifyNumber(
                                        number: data['code']! +
                                            _enterPhoneNumber.text,
                                      )));
                        },
                        style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Don't have an Account?",
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: Text("Sign Up"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
