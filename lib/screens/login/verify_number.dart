import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../main.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber(
      {Key? key, this.number, this.username, this.email, this.page_name})
      : super(key: key);
  final number;
  final username;

  final email;
  final page_name;

  @override
  State<VerifyNumber> createState() =>
      _VerifyNumberState(number, username, email, page_name);
}

class _VerifyNumberState extends State<VerifyNumber> {
  _VerifyNumberState(
      this.phoneNumber, this.username, this.email, this.page_name);

  final phoneNumber;
  final username;

  final email;
  final page_name;

  var _status = Status.Waiting;
  var _verificationId;
  var _textEditingController = TextEditingController();

  //rsa variables
  var key ,pub_key,pri_key;
  var message  ;
  var en_msg , de_msg ;


  // Create storage
  final storage = new FlutterSecureStorage();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // print(phoneNumber);
    super.initState();
    // print(phoneNumber);
    // print(username);
    // print(email);
    // print(page_name);

    _verifyPhoneNumber();
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phonesAuthCredentials) async {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Verified")));
        },
        verificationFailed: (verificationFailed) async {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sorry,Verification Failed")));
        },
        codeSent: (verificationId, resendingToken) async {
          print(verificationId);
          setState(() {
            print("Got the verification ID");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Got the verification ID")));
            this._verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Timeout")));
        });
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (this._verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code!);

      await _auth
          .signInWithCredential(credential)
          .then((value) async {

            //will work if the user is new
            if (page_name == "signup") {

              ////////////////////////////////////////////////////
              ////////////////////generating key//////////////////
              ////////////////////////////////////////////////////

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please wait while the key is being generated")));

              key = await RSA.generate(3072);
              setState((){
                pub_key = key.publicKey ;
                pri_key = key.privateKey ;
              });
              // Write value
              await storage.write(key: "pri_key", value: pri_key);
              // Read value
              // var x = await storage.read(key :"pri_key");
              // print(x);



              var obj1 = await FirebaseFirestore.instance
                  .collection('user')
                  .doc(phoneNumber);
              var UserData = {
                "displayName": username,
                "email": email,
                "groups": [phoneNumber],
                "photoURL": "",
                "uid": phoneNumber,
                "public_key": pub_key,
              };
              await obj1.set(UserData);

              var obj2 = await FirebaseFirestore.instance
                  .collection('group')
                  .doc(phoneNumber);
              var GroupData = {
                "createdAt": DateTime.now(),
                "createdBy": username,
                "members": [
                  {
                    "user_id" : phoneNumber ,
                    "public_key": pub_key,
                  },
                ],
                "id": phoneNumber,
                "modifiedAt": "",
                "name": "Me",
                "recentMessages": {

                  "message_text": "",
                  "readBy":"",
                  "sentAt":"",
                  "sentBy":"",
                },
                "type":"1",

              };
              await obj2.set(GroupData);

              var obj3 = await FirebaseFirestore.instance
                  .collection('group_metadata')
                  .doc(phoneNumber.toString())
                  .collection("group_name")
                  .doc(phoneNumber.toString());
              
              var GroupMetaData = {
                "group_name": "Me",
                "group_id": phoneNumber,
                "last_msg_time": DateTime.now(),
                "msg": "Say Hi",
                "type":"1",
              };
              await obj3.set(GroupMetaData);




              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User Is Added")));
            }
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => HomePage()),
                (route) => false);
          })
          .whenComplete(() {})
          .onError((error, stackTrace) {
            setState(() {
              _textEditingController.text = "";
              this._status = Status.Error;
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Verify Number'),
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
          body: _status != Status.Error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("OTP Verification",
                          style: TextStyle(
                              color: Color(0xFF08C187).withOpacity(0.7),
                              fontSize: 30)),
                    ),
                    Text("Enter OTP sent to",
                        style: TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 20)),
                    Text(
                      phoneNumber == null ? "" : phoneNumber,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'OTP Code',
                          ),
                          onChanged: (value) async {
                            print(value);

                            if (value.length == 6) {
                              //perform the auth verification
                              _sendCodeToFirebase(code: value);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Sending Code to Auth")));
                            }
                          },
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          controller: _textEditingController,
                          keyboardType: TextInputType.number),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive the OTP?"),
                        MaterialButton(
                            child: Text(
                              "RESEND OTP",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              setState(() {
                                this._status = Status.Error;
                              });
                              _verifyPhoneNumber();
                            })
                      ],
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("OTP Verification",
                          style: TextStyle(
                              color: Color(0xFF08C187).withOpacity(0.7),
                              fontSize: 30)),
                    ),
                    Text("The code used is invalid!"),
                    SizedBox(
                      height: 30.0,
                    ),
                    MaterialButton(
                        child: Text(
                          "Edit Number",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context)),
                    MaterialButton(
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                        onPressed: () async {
                          setState(() {
                            this._status = Status.Waiting;
                          });
                          _verifyPhoneNumber();
                        }),
                  ],
                )),
    );
  }
}
