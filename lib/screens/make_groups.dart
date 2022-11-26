import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:link_chat_app/screens/models/user.dart';

import 'chatscreen.dart';

class make_groups extends StatefulWidget {
  const make_groups({Key? key}) : super(key: key);

  @override
  State<make_groups> createState() => _make_groupsState();
}

class _make_groupsState extends State<make_groups> {
  TextEditingController _groupName = new TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Create Groups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
              child: Text("Group Name",
                  style: TextStyle(color: Colors.black26, fontSize: 16)),
            ),
            TextField(
                keyboardType: TextInputType.text,
                controller: _groupName,
                decoration: InputDecoration(
                  // labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
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
                      if (_groupName.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Field cannot be empty"),backgroundColor: Colors.red,));
                      } else {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Please wait while the group is being created"),));
                        // getting the number from storage
                        var number = await storage.read(key: "number");
                        var data = await FirebaseFirestore.instance
                            .collection("user")
                            .doc(number)
                            .get();
                        var obj = user(
                            data['displayName'],
                            data['email'],
                            data['groups'],
                            data['photoURL'],
                            data['public_key'],
                            data['uid']);

                        // generating new group id and adding it to collection
                        String _ModifiedGroupId =
                            number! + "+" + _groupName.text.trim();
                        if (obj.does_group_exist(_ModifiedGroupId.trim()) ==
                            false) {
                          obj.add_groupid(_ModifiedGroupId.trim());
                          await FirebaseFirestore.instance
                              .collection("user")
                              .doc(number)
                              .update(obj.toJson());

                          // print(ModifiedGroupId);
                          var obj2 = await FirebaseFirestore.instance
                              .collection('group')
                              .doc(_ModifiedGroupId);
                          var GroupData = {
                            "createdAt": DateTime.now(),
                            "createdBy": number,
                            "members": [
                              {
                                "user_id": number,
                                "public_key": obj.public_key,
                              },
                            ],
                            "id": _ModifiedGroupId,
                            "modifiedAt": "",
                            "name": _groupName.text.trim(),
                            "recentMessages": {
                              "message_text": "",
                              "readBy": "",
                              "sentAt": "",
                              "sentBy": "",
                            },
                            "type": "1",
                          };
                          await obj2.set(GroupData);

                          var obj3 = await FirebaseFirestore.instance
                              .collection('group_metadata')
                              .doc(number)
                              .collection("group_name")
                              .doc(_ModifiedGroupId);

                          var GroupMetaData = {
                            "group_name": _groupName.text.trim(),
                            "group_id": _ModifiedGroupId,
                            "last_msg_time": DateTime.now(),
                            "msg": "Say Hi",
                            "type": "1",
                          };
                          await obj3.set(GroupMetaData);
                        }
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Group Created Successfully"),backgroundColor: Colors.green,));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => chatscreen(
                            groupname: _groupName.text.trim() ,
                            groupid: _ModifiedGroupId,
                            userid: number,
                          ),
                        ));
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
