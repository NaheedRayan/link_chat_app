import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'add_friend.dart';
import 'models/chatMessageModel.dart';
import 'models/group_collection.dart';
import 'models/message_chat.dart';

class chatscreen extends StatefulWidget {
  final String groupname;
  final String groupid;

  const chatscreen({Key? key, required this.groupname, required this.groupid})
      : super(key: key);

  @override
  State<chatscreen> createState() => _chatscreenState(groupname, groupid);
}

class _chatscreenState extends State<chatscreen> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

  final storage = new FlutterSecureStorage();

  // String groupChatId = "ok";
  TextEditingController _text_message = new TextEditingController();

  final String groupname;
  final String groupid;

  _chatscreenState(String this.groupname, String this.groupid);

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
            color: Colors.white60,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                // _showDialog(context);
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text("button 1"),));
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
    var _limit = 50;
    return Flexible(
      child: groupid.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(groupid)
                  .collection("messages")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var listMessage = snapshot.data!.docs;
                  if (listMessage.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),

                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),

                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      // controller: listScrollController,
                    );
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
  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      // if (messageChat.idFrom == currentUserId) {
      if (true) {
        // var x =  storage.read(key :"pri_key");
        // print(x);
        // Right (my message)
        return Row(
          children: <Widget>[
            Container(
              child: Text(
                messageChat.msgText,
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width:300,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8)),
              // margin: EdgeInsets.only(
              //     bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      }
      else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              // Row(
              //   children: <Widget>[
              //     isLastMessageLeft(index)
              //         ? Material(
              //             child: Image.network(
              //               widget.arguments.peerAvatar,
              //               loadingBuilder: (BuildContext context, Widget child,
              //                   ImageChunkEvent? loadingProgress) {
              //                 if (loadingProgress == null) return child;
              //                 return Center(
              //                   child: CircularProgressIndicator(
              //                     color: ColorConstants.themeColor,
              //                     value: loadingProgress.expectedTotalBytes !=
              //                             null
              //                         ? loadingProgress.cumulativeBytesLoaded /
              //                             loadingProgress.expectedTotalBytes!
              //                         : null,
              //                   ),
              //                 );
              //               },
              //               errorBuilder: (context, object, stackTrace) {
              //                 return Icon(
              //                   Icons.account_circle,
              //                   size: 35,
              //                   color: ColorConstants.greyColor,
              //                 );
              //               },
              //               width: 35,
              //               height: 35,
              //               fit: BoxFit.cover,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(18),
              //             ),
              //             clipBehavior: Clip.hardEdge,
              //           )
              //         : Container(width: 35),
              //     messageChat.type == TypeMessage.text
              //         ? Container(
              //             child: Text(
              //               messageChat.content,
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              //             width: 200,
              //             decoration: BoxDecoration(
              //                 color: ColorConstants.primaryColor,
              //                 borderRadius: BorderRadius.circular(8)),
              //             margin: EdgeInsets.only(left: 10),
              //           )
              //         : messageChat.type == TypeMessage.image
              //             ? Container(
              //                 child: TextButton(
              //                   child: Material(
              //                     child: Image.network(
              //                       messageChat.content,
              //                       loadingBuilder: (BuildContext context,
              //                           Widget child,
              //                           ImageChunkEvent? loadingProgress) {
              //                         if (loadingProgress == null) return child;
              //                         return Container(
              //                           decoration: BoxDecoration(
              //                             color: ColorConstants.greyColor2,
              //                             borderRadius: BorderRadius.all(
              //                               Radius.circular(8),
              //                             ),
              //                           ),
              //                           width: 200,
              //                           height: 200,
              //                           child: Center(
              //                             child: CircularProgressIndicator(
              //                               color: ColorConstants.themeColor,
              //                               value: loadingProgress
              //                                           .expectedTotalBytes !=
              //                                       null
              //                                   ? loadingProgress
              //                                           .cumulativeBytesLoaded /
              //                                       loadingProgress
              //                                           .expectedTotalBytes!
              //                                   : null,
              //                             ),
              //                           ),
              //                         );
              //                       },
              //                       errorBuilder:
              //                           (context, object, stackTrace) =>
              //                               Material(
              //                         child: Image.asset(
              //                           'images/img_not_available.jpeg',
              //                           width: 200,
              //                           height: 200,
              //                           fit: BoxFit.cover,
              //                         ),
              //                         borderRadius: BorderRadius.all(
              //                           Radius.circular(8),
              //                         ),
              //                         clipBehavior: Clip.hardEdge,
              //                       ),
              //                       width: 200,
              //                       height: 200,
              //                       fit: BoxFit.cover,
              //                     ),
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(8)),
              //                     clipBehavior: Clip.hardEdge,
              //                   ),
              //                   onPressed: () {
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => FullPhotoPage(
              //                             url: messageChat.content),
              //                       ),
              //                     );
              //                   },
              //                   style: ButtonStyle(
              //                       padding:
              //                           MaterialStateProperty.all<EdgeInsets>(
              //                               EdgeInsets.all(0))),
              //                 ),
              //                 margin: EdgeInsets.only(left: 10),
              //               )
              //             : Container(
              //                 child: Image.asset(
              //                   'images/${messageChat.content}.gif',
              //                   width: 100,
              //                   height: 100,
              //                   fit: BoxFit.cover,
              //                 ),
              //                 margin: EdgeInsets.only(
              //                     bottom: isLastMessageRight(index) ? 20 : 10,
              //                     right: 10),
              //               ),
              //   ],
              // ),
              //
              // // Time
              // isLastMessageLeft(index)
              //     ? Container(
              //         child: Text(
              //           DateFormat('dd MMM kk:mm').format(
              //               DateTime.fromMillisecondsSinceEpoch(
              //                   int.parse(messageChat.timestamp))),
              //           style: TextStyle(
              //               color: ColorConstants.greyColor,
              //               fontSize: 12,
              //               fontStyle: FontStyle.italic),
              //         ),
              //         margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
              //       )
              //     : SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10),
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
                  // getting the number from storage
                  var number = await storage.read(key: "number");
                  var groupId = number! + "+" + groupname;

                  var group_data = await FirebaseFirestore.instance
                      .collection("group")
                      .doc(groupId)
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

                  await group_collection_obj.sendMessage(
                      number, groupId, _text_message.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Message Sent"),
                    backgroundColor: Colors.green,
                  ));

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

}
