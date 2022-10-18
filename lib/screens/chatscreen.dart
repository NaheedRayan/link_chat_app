import 'package:flutter/material.dart';

class chatscreen extends StatelessWidget {
  final String groupname;
  const chatscreen({Key? key,required this.groupname}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(groupname),

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
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("button 1"),));
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

    );
  }
}
