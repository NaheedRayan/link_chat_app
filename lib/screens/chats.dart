
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasError){
              return Center(child: Text('Something went wrong'),);
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading'),);
          }

          if(snapshot.hasData){
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text("Chats"),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                      snapshot.data!.docs.map((DocumentSnapshot document){
                      Map<dynamic,dynamic>data=document.data()! as Map;

                    return CupertinoListTile(
                      title: Text(data["msg"]),
                    );
                  }).toList()
                ))
              ],
            );

          }
          return Container();
        });
  }
}



//
// class Chats extends StatelessWidget {
//   const Chats({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//
//
//       slivers: [
//         CupertinoSliverNavigationBar(
//           largeTitle: Text("Hello"),
//         ),
//
//         SliverList(delegate: SliverChildListDelegate([
//           CupertinoListTile(
//             title: Text('Chat1'),
//           ),
//           CupertinoListTile(
//             title: Text('Chat1'),
//           ),
//           CupertinoListTile(
//             title: Text('Chat1'),
//           ),
//
//         ]))
//       ],
//     );
//   }
// }
