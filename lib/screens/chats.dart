import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_chat_app/components/profile_pic.dart';
import 'package:link_chat_app/main.dart';
import 'package:link_chat_app/screens/chatscreen.dart';
import 'package:link_chat_app/screens/make_groups.dart';

import '../components/logo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController searchTextEditingController =
      new TextEditingController();

  get prefixIcon => null;

  static get groupname => null;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<dynamic>(

        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var number = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  // leading:  ProfilePic(height: 5.0, width: 5.0, radius: 15.0),
                  // leading: Icon(Icons.account_circle_rounded),

                  title: Text("Link"),

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
                body: Column(
                  children: [
                    // new code for search
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Search",
                          prefixIcon: prefixIcon ?? Icon(Icons.search),
                          isDense: true,
                          // Added this
                          contentPadding: EdgeInsets.all(8),
                          // Added this

                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('group_metadata')
                            .doc(number)
                            .collection("group_name")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          if (snapshot.hasData) {
                            final data = snapshot.requireData;

                            return ListView.builder(
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                var myDateTime =
                                    data.docs[index]["last_msg_time"].toDate();
                                var formatted_date = DateFormat('hh:mm a')
                                    .format(myDateTime); // 12/31, 10:00 PM

                                return ListTile(
                                  //new code....................................................
                                  onTap: () {
                                    //navigator for new chatscreen for groups or user
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => chatscreen(
                                        groupname: data.docs[index]
                                            ["group_name"],
                                      ),
                                    ));
                                  },

                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18.0,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "images/profile_pic.png",
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    data.docs[index]["group_name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    data.docs[index]["msg"],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  trailing: Text(
                                    // DateTime dt = (map['timestamp'] as Timestamp).toDate();
                                    // data.docs[index]["last_msg_time"].toDate().toString() ,
                                    formatted_date,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Text("Loading");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => make_groups(),
                      fullscreenDialog: true,
                    ));
                    // Respond to button press



                  },
                  child: Icon(Icons.add),
                  // mini: true,
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  callAsyncFetch() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "number");
    print("-------------------------");
    print(number);
    return number;
  }
}
