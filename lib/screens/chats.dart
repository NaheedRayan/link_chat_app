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

  TextEditingController searchTextEditingController = new TextEditingController();

  get prefixIcon => null;



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
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

          // new code for search
          Container(
            padding: const EdgeInsets.fromLTRB(20.0,7.0,20.0,15.0),
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: TextField(

                  controller: searchTextEditingController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,

                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: " search username",
                      prefixIcon: prefixIcon??Icon(Icons.search),

                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(55),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                    ),
                ),
                ),

                // search button for search off now
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: GestureDetector(
                //     onTap: (){
                //       //initiateSearch();
                //     },
                //     child: Container(
                //         height: 40,
                //         width: 40,
                //         decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //             colors: [
                //               const Color(0xFF02FC23),
                //               const Color(0xF200BE25),
                //             ],
                //           ),
                //           borderRadius: BorderRadius.circular(25),
                //         ),
                //         padding: EdgeInsets.all(10),
                //         child: Image.asset("images/search_white.png")
                //     ),
                //   ),
                // ),
              ],
            ),
          ),


          Expanded(
            child: ListView.builder(
              // Let the ListView know how many items it needs to build.
              itemCount: items.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18.0,
                    child: ClipOval(
                    child: Image.asset("images/profile_pic.png",
                   ),
                   ),
                  ),
                  title: Text(
                    "Ashraf",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  subtitle: Text(
                     "test massage get",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),

                  trailing: Text(
                    "12 sep \n 10.00pm",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                );
              },//item
            ),
          ),
        ],
      ),
    );
  }
}
