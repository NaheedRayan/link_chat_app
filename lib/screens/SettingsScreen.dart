import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_chat_app/screens/login/hello.dart';
import 'package:link_chat_app/settings/account_page.dart';
import 'package:link_chat_app/widget/icon_widget.dart';
import 'package:link_chat_app/widget/utils.dart';
import 'models/user.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}



class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // leading:  ProfilePic(height: 5.0, width: 5.0, radius: 15.0),
        // leading: Icon(Icons.account_circle_rounded),

        title: Text("Settings"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(

        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+1 90211 44 44',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                AccountPage(),
                NotificationsPage(),
                buildLogout(),
                buildDeleteAccount(),
              ],
            ),
            const SizedBox(height: 32),
            SettingsGroup(
              title: 'FEEDBACK',
              children: <Widget>[
                const SizedBox(height: 8),
                buildPrivacy(context),
                buildSecurity(context),
                buildAccountInfo(context),
                buildReportBug(context),
                buildSendFeedback(context),
              ],
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   child: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           CupertinoButton.filled(child: Text("Logout"), onPressed: (){
    //             FirebaseAuth.instance.signOut();
    //             Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => Hello()), (route) => false);
    //             Fluttertoast.showToast(
    //                 msg: "Logout Successful",
    //                 toastLength: Toast.LENGTH_SHORT,
    //                 gravity: ToastGravity.BOTTOM,
    //                 timeInSecForIosWeb: 2,
    //                 backgroundColor: Colors.green,
    //                 textColor: Colors.white,
    //                 fontSize: 16.0
    //             );
    //
    //           })
    //         ],
    //       )
    //   ),
    // );
  }

  Widget NotificationsPage() => SimpleSettingsTile(
    title: 'Appearence',
    subtitle: '',
    leading: IconWidget(icon: Icons.sunny, color: Colors.blueAccent),
    onTap: () {
    },
  );

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
    leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
    onTap: () async{
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Hello())
      );
    }
  );

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
    title: 'Privacy',
    subtitle: '',
    leading: IconWidget(icon: Icons.lock, color: Colors.blue),
    onTap: () => Utils.showSnackBar(context, 'Clicked Privacy'),
  );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
    title: 'Security',
    subtitle: '',
    leading: IconWidget(icon: Icons.security, color: Colors.red),
    onTap: () => Utils.showSnackBar(context, 'Clicked Security'),
  );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
    title: 'Account Info',
    subtitle: '',
    leading: IconWidget(icon: Icons.text_snippet, color: Colors.purple),
    onTap: () => Utils.showSnackBar(context, 'Clicked Account Info'),
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: IconWidget(icon: Icons.delete, color: Colors.pink),
    onTap: (){
    },
  );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
    title: 'Report A Bug',
    subtitle: '',
    leading: IconWidget(icon: Icons.bug_report, color: Colors.teal),
    onTap: (){
    },
  );

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
    title: 'Send Feedback',
    subtitle: '',
    leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
    onTap: (){
    },
  );
}


