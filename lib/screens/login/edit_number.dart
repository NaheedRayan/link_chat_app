import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          appBar: AppBar(
            title: const Text('Edit Number'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(width: 50.0, height: 50.0, radius: 25.0),
                  Text("SignIn",
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
                    style: TextStyle(color: Color(0xFF08C187), fontSize: 25)),
              ),

              Divider(height: 1, color: Colors.grey, endIndent: 16, indent: 16),
              // THIS
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
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
                    )
                  ],
                ),
              ),

              Text("You will receive an activation code in short time",
                  style: TextStyle(
                      color: CupertinoColors.systemGrey, fontSize: 15)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ));
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ElevatedButton(
                  child: Text("Request code"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => VerifyNumber(
                                  number:
                                      data['code']! + _enterPhoneNumber.text,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(fontSize: 20)),
                ),
              )
            ],
          )),
    );
  }
}
