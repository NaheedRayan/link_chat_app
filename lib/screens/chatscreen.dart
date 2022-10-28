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

      body:  Stack(
        children: <Widget>[

          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.greenAccent[100]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),


    );
  }
}
