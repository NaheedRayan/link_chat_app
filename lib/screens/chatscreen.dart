import 'package:flutter/material.dart';

import 'add_friend.dart';
import 'models/chatMessageModel.dart';

class chatscreen extends StatefulWidget {
  final String groupname;
  const chatscreen({Key? key,required this.groupname}) : super(key: key);

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

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
                    Icon(Icons.people_alt , color: Colors.black54,),
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
                    Icon(Icons.chrome_reader_mode,color: Colors.black54,),
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
            color:  Colors.white60,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                // _showDialog(context);
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text("button 1"),));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => add_friend(group_name:widget.groupname,),
                  fullscreenDialog: true,
                ));
                // if value 2 show dialog
              } else if (value == 2) {
                // _showDialog(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("button 2"),));
              }
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body:  SafeArea(
        child: WillPopScope(
          onWillPop: ()async { return true ;},
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  // buildListMessage(),

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

  // Widget buildListMessage() {}

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

                color: Theme.of(context).primaryColor, onPressed: () {  },
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: (){},
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
                onSubmitted: (value) {
                  // onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style: TextStyle(color: Colors.black87, fontSize: 15),
                // controller: textEditingController,
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
                onPressed: () {},
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
          border: Border(top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5)), color: Colors.white),
    );
  }
}
