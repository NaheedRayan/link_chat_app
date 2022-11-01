import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:link_chat_app/widget/icon_widget.dart';
import 'package:link_chat_app/widget/utils.dart';


class AccountPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: 'Account',
        subtitle: 'Update,Password',
        leading: IconWidget(icon: Icons.person, color: Colors.green),
        child: SettingsScreen(
          title: 'Account',
          children: <Widget>[

          ],
        ),
      );

}
