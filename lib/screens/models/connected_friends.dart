import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class connected_friends{
  var _userid;

  connected_friends(this._userid);

  get userid => _userid;

  set userid(value) {
    _userid = value;
  }




  Future<List> run() async{
    var userdata = await FirebaseFirestore.instance.collection("user")
        .doc(_userid)
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

    return final_conn_user_list ;
  }
}