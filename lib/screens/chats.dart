import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_chat_app/components/profile_pic.dart';

import '../components/logo.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<String> items = List<String>.generate(10, (i) => (i + 1).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading:  ProfilePic(height: 5.0, width: 5.0, radius: 15.0),
        // leading: Icon(Icons.account_circle_rounded),

        title: Text("Link"),

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0,0.0,20.0,0.0),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
                keyboardType: TextInputType.text,
                // controller: _enterUsername,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          Expanded(
            child: ListView.builder(
              // Let the ListView know how many items it needs to build.
              itemCount: items.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  child: Column(
                    children: [Text("data")],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
