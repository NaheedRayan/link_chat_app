import 'package:cloud_firestore/cloud_firestore.dart';
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


  @override
  initState() {
    print("initState Called");
    // final storage = new FlutterSecureStorage();
    // var number = await storage.read(key: "number");
  }


  get prefixIcon => null;
  var connected_user_list = [];
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            connected_user_list = snapshot.data;
            print("outside $connected_user_list");


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
                          title: Text("ok"),
                          subtitle: Text("kol"),


                        );
                      },
                    ),
                  ),
                ],
              ),

            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  callAsyncFetch() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "number");

    // var datalist = new connected_friends(number);
    // print(datalist.run());

    var userdata = await FirebaseFirestore.instance.collection("user")
        .doc(number)
        .get();


    var _groups_id_list = userdata['groups'];

    var conn_user = <String>{};

    for(int i = 0 ; i < _groups_id_list.length ; i++){
      var groupdata = await FirebaseFirestore.instance.collection("group").doc(_groups_id_list[i]).get();
      var members = groupdata["members"];
      for(int j = 0 ; j < members.length ; j++){
        conn_user.add(members[j]["user_id"]);
      }
    }
    // print(_groups_id_list);
    // print(conn_user);


    var final_conn_user_list = [];
    conn_user.forEach((element) async {
      var userdata = await FirebaseFirestore.instance.collection("user").doc(element).get();
      var data = {
        "username" : userdata["displayName"],
        "email":userdata["email"],
        "userid":element,
      };
      final_conn_user_list.add(data);
      // print(data);
    });


    connected_user_list = final_conn_user_list ;

    // var x = await datalist.run();
    print("Inside fun   $final_conn_user_list");
    return final_conn_user_list;
  }
}
