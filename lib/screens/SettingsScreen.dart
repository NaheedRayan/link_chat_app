import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:link_chat_app/screens/login/hello.dart';
import 'package:link_chat_app/settings/AccountPage.dart';
import 'package:link_chat_app/settings/Privacy.dart';
import 'package:link_chat_app/settings/Security.dart';

// import 'package:link_chat_app/settings/AccountPage.dart';
// import 'package:link_chat_app/settings/account_page.dart';
import 'package:link_chat_app/widget/icon_widget.dart';

// import 'package:link_chat_app/widget/utils.dart';
// import 'models/user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: asyncFunc(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var userdata = snapshot.data;
            // print(userdata["email"]);

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
                          child: Image.asset(
                            'images/profile_pic.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userdata["displayName"]}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${userdata["uid"]}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'GENERAL',
                      children: <Widget>[
                        // AccountPage(userdata),
                        AccountPage(userdata),
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
                        buildReportBug(context),
                        buildSendFeedback(context),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else
            return CircularProgressIndicator();
        });
  }

  asyncFunc() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "number");

    var user =
        await FirebaseFirestore.instance.collection("user").doc(number).get();
    return user;
  }

  Widget NotificationsPage() => SimpleSettingsTile(
        title: 'Appearence',
        subtitle: '',
        leading: IconWidget(icon: Icons.sunny, color: Colors.blueAccent),
        onTap: () {},
      );

  Widget buildLogout() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: '',
      leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () async {
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => Hello()),(Route<dynamic> route) => false);
      });

  Widget AccountPage(userdata) => SimpleSettingsTile(
      title: 'Account',
      subtitle: 'Update,Password',
      leading: IconWidget(icon: Icons.person, color: Colors.green),
      onTap: () async {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => accountpage(
          username:userdata["displayName"],
          email:userdata["email"],
          number:userdata["uid"],
          public_key:userdata["public_key"],


        )));
      });

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
        title: 'Privacy',
        subtitle: '',
        leading: IconWidget(icon: Icons.lock, color: Colors.blue),
        onTap: () => {
        Navigator.push(
        context, MaterialPageRoute(builder: (context) => privacy()))
        }
      );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: 'Security',
        subtitle: '',
        leading: IconWidget(icon: Icons.security, color: Colors.red),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => security()));

        }
      );

  Widget buildDeleteAccount() => SimpleSettingsTile(
        title: 'Delete Account',
        subtitle: '',
        leading: IconWidget(icon: Icons.delete, color: Colors.pink),
        onTap: () {},
      );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
        title: 'Report A Bug',
        subtitle: '',
        leading: IconWidget(icon: Icons.bug_report, color: Colors.teal),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Report A Bug"),
          ));
        },
      );

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
        title: 'Send Feedback',
        subtitle: '',
        leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Send Feedback"),
        )),
      );
}
