import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:link_chat_app/screens/models/connected_friends.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  TextEditingController searchTextEditingController =
      new TextEditingController();



  get prefixIcon => null;
  var connected_user_list = [];
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            connected_user_list = snapshot.data;
            // print("outside $connected_user_list");


            return Scaffold(
              appBar: AppBar(
                title: Text("Connected People"),
                actions: [
                  PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      // popupmenu item 1
                      PopupMenuItem(
                        value: 1,
                        // row has two child icon and text.
                        child: Row(
                          children: [
                            Icon(
                              Icons.ads_click,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              // sized box with width 10
                              width: 10,
                            ),
                            Text("Option 1")
                          ],
                        ),
                      ),
                      // popupmenu item 2
                      PopupMenuItem(
                        value: 2,
                        // row has two child icon and text
                        child: Row(
                          children: [
                            Icon(
                              Icons.ads_click,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              // sized box with width 10
                              width: 10,
                            ),
                            Text("Option 2")
                          ],
                        ),
                      ),
                    ],
                    offset: Offset(0, 60),
                    color: Colors.green[100]!,
                    elevation: 2,
                    // // on selected we show the dialog box
                    // onSelected: (value) {
                    //   // if value 1 show dialog
                    //   if (value == 1) {
                    //     // if value 2 show dialog
                    //   } else if (value == 2) {}
                    // },
                  ),
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
                    child: ListView.builder(
                      itemCount: connected_user_list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          //new code....................................................
                          onTap: () {
                            // //navigator for new chatscreen for groups or user
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(
                            //   builder: (context) => chatscreen(
                            //     groupname: data.docs[index]["group_name"],
                            //     groupid: data.docs[index]["group_id"],
                            //   ),
                            // ));
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
                            "${connected_user_list[index]["username"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          subtitle: Text(
                            "Email     : ${connected_user_list[index]['email']}\nNumber : ${connected_user_list[index]["userid"]}" ,

                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          isThreeLine: true,

                          trailing: Text(

                            "Active",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            );
          }
          else {
            return CircularProgressIndicator();
          }
        });
  }

  callAsyncFetch() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "number");

    var datalist = new connected_friends(number);
    // print(datalist.run());

    var x = await datalist.run();
    // print("Inside fun   $x");
    return x;
  }
}
