import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:link_chat_app/screens/models/group_collection.dart';

class add_friend extends StatefulWidget {
  final String group_name ;
  const add_friend({Key? key, required String this.group_name}) : super(key: key);

  @override
  State<add_friend> createState() => _add_friendState(group_name);
}

class _add_friendState extends State<add_friend> {


  TextEditingController _friendId = new TextEditingController();
  final storage = new FlutterSecureStorage();
  final String group_name ;

  _add_friendState(String this.group_name);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Add friend"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
              child: Text("Friend Number",
                  style: TextStyle(color: Colors.black26, fontSize: 16)),
            ),
            IntlPhoneField(
                keyboardType: TextInputType.number,
                controller: _friendId,
                decoration: InputDecoration(
                  // labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'BD',

                style: TextStyle(
                  fontSize: 20,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    child: Text("Add"),
                    onPressed: () async {

                      // print(_friendId.text.trim());
                      if (_friendId.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Field cannot be empty"),backgroundColor: Colors.red,));
                      } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Please wait the user is added"),));
                          // getting the number from storage

                          var number = await storage.read(key: "number");

                          var groupId = number! + "+" + group_name ;

                          // print(group_name);
                          // print(groupId);
                          var group_data = await FirebaseFirestore.instance
                              .collection("group")
                              .doc(groupId)
                              .get();

                          var group_collection_obj = group_collection(group_data["createdAt"], group_data["createdBy"], group_data["id"], group_data["members"], group_data["modifiedAt"], group_data["name"], group_data["recentMessages"], group_data["type"]);


                          var friend_id = "+880"+_friendId.text.trim();
                          // print(friend_id);


                          var friend_exist = await FirebaseFirestore.instance.collection("user").doc(friend_id).get();
                          if(friend_exist.exists){
                            // print("The user exists");
                            if(group_collection_obj.does_friendId_exist(friend_id)){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("The user is already in the group"),backgroundColor: Colors.red,));
                            }
                            else{
                              group_collection_obj.add_user(friend_id , friend_exist["public_key"]);
                              await FirebaseFirestore.instance.collection("group").doc(groupId).update(group_collection_obj.toJson());

                                  var obj3 = await FirebaseFirestore.instance
                                      .collection('group_metadata')
                                      .doc(number)
                                      .collection("group_name")
                                      .doc(groupId);

                                  var GroupMetaData = {
                                    "group_name": group_name,
                                    "group_id": groupId,
                                    "last_msg_time": DateTime.now(),
                                    "msg": "New User added",
                                    "type": "2",
                                  };
                                  await obj3.set(GroupMetaData);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("User Added"),backgroundColor: Colors.green,));

                              Navigator.of(context).pop();

                            }


                          }
                          else{
                            // print("The user doesn't exists");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("The User Doesn't exist"),backgroundColor: Colors.red,));

                          }

                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
