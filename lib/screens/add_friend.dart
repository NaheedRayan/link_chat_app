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
                            }


                          }
                          else{
                            // print("The user doesn't exists");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("The User Doesn't exist"),backgroundColor: Colors.red,));

                          }

                        //   var obj = user(
                        //       data['displayName'],
                        //       data['email'],
                        //       data['groups'],
                        //       data['photoURL'],
                        //       data['public_key'],
                        //       data['uid']);
                        //
                        //   // generating new group id and adding it to collection
                        //   String _ModifiedGroupId =
                        //       number! + "+" + _groupName.text.trim();
                        //   if (obj.does_group_exist(_ModifiedGroupId.trim()) ==
                        //       false) {
                        //     obj.add_groupid(_ModifiedGroupId.trim());
                        //     await FirebaseFirestore.instance
                        //         .collection("user")
                        //         .doc(number)
                        //         .update(obj.toJson());
                        //
                        //     // print(ModifiedGroupId);
                        //     var obj2 = await FirebaseFirestore.instance
                        //         .collection('group')
                        //         .doc(_ModifiedGroupId);
                        //     var GroupData = {
                        //       "createdAt": DateTime.now(),
                        //       "createdBy": number,
                        //       "members": [
                        //         {
                        //           "user_id": number,
                        //           "public_key": obj.public_key,
                        //         },
                        //       ],
                        //       "id": _ModifiedGroupId,
                        //       "modifiedAt": "",
                        //       "name": _groupName.text.trim(),
                        //       "recentMessages": {
                        //         "message_text": "",
                        //         "readBy": "",
                        //         "sentAt": "",
                        //         "sentBy": "",
                        //       },
                        //       "type": "1",
                        //     };
                        //     await obj2.set(GroupData);
                        //
                        //     var obj3 = await FirebaseFirestore.instance
                        //         .collection('group_metadata')
                        //         .doc(number)
                        //         .collection("group_name")
                        //         .doc(_ModifiedGroupId);
                        //
                        //     var GroupMetaData = {
                        //       "group_name": _groupName.text.trim(),
                        //       "group_id": _ModifiedGroupId,
                        //       "last_msg_time": DateTime.now(),
                        //       "msg": "Say Hi",
                        //       "type": "1",
                        //     };
                        //     await obj3.set(GroupMetaData);
                        //   }
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(SnackBar(content: Text("Group Created Successfully"),backgroundColor: Colors.green,));
                        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => chatscreen(
                        //       groupname: _groupName.text.trim() ,
                        //     ),
                        //   ));
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
