import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'add_friend.dart';
// import 'models/chatMessageModel.dart';
import 'models/group_collection.dart';

class chatscreen extends StatefulWidget {
  final String groupname;
  final String groupid;

  const chatscreen({Key? key, required this.groupname, required this.groupid})
      : super(key: key);

  @override
  State<chatscreen> createState() => _chatscreenState(groupname, groupid);
}

class _chatscreenState extends State<chatscreen> {
  ///////////////////////////////////////////////////////
  //  var msg_list = [];

  final storage = new FlutterSecureStorage();

  // String groupChatId = "ok";
  TextEditingController _text_message = new TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final String groupname;
  final String groupid;

  int _limit = 40;
  int _limitIncrement = 20;

  _chatscreenState(String this.groupname, String this.groupid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listScrollController.addListener(_scrollListener);

  }


  // for loading when we scroll
  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange ) {
      print(_limit);

      setState(() {
        _limit += _limitIncrement;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupname),
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
                      Icons.people_alt,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Add Friend")
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
                      Icons.chrome_reader_mode,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("About")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 60),
            color: Colors.green[100],
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
               ;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => add_friend(
                    group_name: widget.groupname,
                  ),
                  fullscreenDialog: true,
                ));
                // if value 2 show dialog
              } else if (value == 2) {
                // _showDialog(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("button 2"),
                ));
              }
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // // Sticker
                  // isShowSticker ? buildSticker() : SizedBox.shrink(),

                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              // buildLoading()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListMessage() {

    return Flexible(
      child: groupid.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(groupid)
                  .collection("messages")
                  .orderBy("sentAt", descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var listMessage = snapshot.data!.docs;
                  if (listMessage.length > 0) {
                    return FutureBuilder<dynamic>(
                        future: decryptMsg(listMessage),
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            // print(snapshot.data);
                            // return Text(snapshot.data);

                            return ListView.builder(
                              padding: EdgeInsets.all(10),
                              itemBuilder: (context, index) =>
                                  buildItem(index, snapshot.data?[index]),

                              itemCount: snapshot.data?.length,
                              reverse: true,
                              controller: listScrollController,
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  } else {
                    return Center(child: Text("No message here yet..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
    );
  }

  Widget buildItem(int index, document) {
    if (document != null) {
      if (document["sentBy"] == document["sentTo"]) {
        //   if (false) {
        // Right (my message)
        return Row(
          children: <Widget>[
            Container(
              child: Text(
                // messageChat.msgText,
                document["msgText"],
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              // width: 300,
              constraints: BoxConstraints(maxWidth: 270),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(bottom: 3),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  document["sentByUserName"],
                  style: TextStyle(color: Colors.grey),
                ),
                margin: EdgeInsets.only(left: 4, bottom: 2),
              ),
              Container(
                child: Text(
                  document["msgText"],
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                // width: 200,
                constraints: BoxConstraints(maxWidth: 270),
                decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(bottom: 3),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          // margin: EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.add),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {},
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: TextField(
                // onSubmitted: (value) {
                //   // onSendMessage(textEditingController.text, TypeMessage.text);
                //   print(value);
                // },
                style: TextStyle(color: Colors.black87, fontSize: 15),
                controller: _text_message,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.black26),
                ),

                // focusNode: focusNode,
                autofocus: true,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send_rounded),
                onPressed: () async {

                  HapticFeedback.mediumImpact();

                  // getting the number from storage
                  var number = await storage.read(key: "number");
                  // var groupId = number! + "+" + groupname;

                  /////////////////////////////////////////////////////////////////////////////wrong
                  // print(groupId);

                  var group_data = await FirebaseFirestore.instance
                      .collection("group")
                      .doc(groupid)
                      .get();

                  var group_collection_obj = group_collection(
                      group_data["createdAt"],
                      group_data["createdBy"],
                      group_data["id"],
                      group_data["members"],
                      group_data["modifiedAt"],
                      group_data["name"],
                      group_data["recentMessages"],
                      group_data["type"]);

                  var msg_data = {
                    "msgText": _text_message.text.trim(),
                    "sentAt": DateTime.now(),
                    "sentBy": number,
                    "sentTo": number,
                    "sentByUserName": "test"
                  };
                  // setState(() => msg_list.add(msg_data));
                  await group_collection_obj.sendMessage(
                      number!, groupid, _text_message.text.trim());
                  _text_message.clear();
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text("Message Sent"),
                  //   backgroundColor: Colors.green,
                  // ));

                  // print(_text_message.text);
                  // print(groupname);
                  // print(groupId);
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).primaryColor, width: 0.5)),
          color: Colors.white),
    );
  }

  decryptMsg(List<QueryDocumentSnapshot<Object?>> listMessage) async {
    var private_key = await storage.read(key: "pri_key");
    var userid = await storage.read(key: "number");
    print(private_key);

    var msg_list = [];
    for (int i = 0; i < listMessage.length; i++) {
      if (listMessage[i].get("sentTo") == userid) {

        // print("--------------$i--------------");

        var de_msg = await RSA.decryptPKCS1v15(
            listMessage[i].get("msgText"), private_key!);
        // print("++++++++++++++$i++++++++++++++");

        var data = {
          "msgText": de_msg,
          "sentAt": listMessage[i].get("sentAt"),
          "sentBy": listMessage[i].get("sentBy"),
          "sentTo": listMessage[i].get("sentTo"),
          "sentByUserName": listMessage[i].get("sentByUserName")
        };
        msg_list.add(data);
        // print(de_msg);
      }
    }

    return msg_list;
  }
}
