import 'package:flutter/material.dart';

class chatscreen extends StatelessWidget {
  final String groupname;
  const chatscreen({Key? key,required this.groupname}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(groupname),

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Container(
              width: 30,
              child: Image.asset(
                'images/profile_pic.png',
              ),
            ),
          ),
          Icon(Icons.more_vert),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),

    );
  }
}
