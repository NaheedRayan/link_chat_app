import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_chat_app/screens/login/user_name.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key, this.number}) : super(key: key);
  final number;

  @override
  State<VerifyNumber> createState() => _VerifyNumberState(number);
}

class _VerifyNumberState extends State<VerifyNumber> {

  final phoneNumber;
  _VerifyNumberState(this.phoneNumber);
  var _status = Status.Waiting;
  var _verificationId;
  var _textEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // print(phoneNumber);
    super.initState();
    _verifyPhoneNumber();
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phonesAuthCredentials) async {Fluttertoast.showToast(
              msg: "Verified",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );},
        verificationFailed: (verificationFailed) async {print("Sorry . Verification failed");Fluttertoast.showToast(
              msg: "Sorry,verfication failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );},
        codeSent: (verificationId, resendingToken) async {
          print(verificationId);
          setState(() {
            print("Got the verification ID");
            Fluttertoast.showToast(
                msg: "Got the verification ID",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
            this._verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {Fluttertoast.showToast(
              msg: "Timeout",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );});
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (this._verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code!);

      await _auth
          .signInWithCredential(credential)
          .then((value) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => UserName()));
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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Verify Number'),
          previousPageTitle: "Edit Number",
        ),
        child: _status != Status.Error
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
                          color: CupertinoColors.secondaryLabel, fontSize: 20)),
                  Text(
                    phoneNumber == null ? "" : phoneNumber,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        onChanged: (value) async {
                          print(value);
                          if (value.length == 6) {
                            //perform the auth verification
                            _sendCodeToFirebase(code: value);
                            Fluttertoast.showToast(
                                msg: "Sending Code to auth",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(letterSpacing: 30, fontSize: 30),
                        maxLength: 6,
                        controller: _textEditingController,
                        keyboardType: TextInputType.number),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the OTP?"),
                      CupertinoButton(
                          child: Text("RESEND OTP"),
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
                  CupertinoButton(
                      child: Text("Edit Number"),
                      onPressed: () => Navigator.pop(context)),
                  CupertinoButton(
                      child: Text("Resend Code"),
                      onPressed: () async {
                        setState(() {
                          this._status = Status.Waiting;
                        });

                        _verifyPhoneNumber();
                      }),
                ],
              ));
  }
}
