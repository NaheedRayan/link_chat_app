

class group_collection{

  var _created_at;
  var _created_by;
  var _id ;
  var _members ;
  var _modified_at;
  var _name ;
  var _recent_messages ;
  var _type ;


  group_collection(this._created_at, this._created_by, this._id, this._members,
      this._modified_at, this._name, this._recent_messages, this._type);

  get type => _type;

  set type(value) {
    _type = value;
  }

  get recent_messages => _recent_messages;

  set recent_messages(value) {
    _recent_messages = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get modified_at => _modified_at;

  set modified_at(value) {
    _modified_at = value;
  }

  get members => _members;

  set members(value) {
    _members = value;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  get created_by => _created_by;

  set created_by(value) {
    _created_by = value;
  }

  get created_at => _created_at;

  set created_at(value) {
    _created_at = value;
  }





  bool does_friendId_exist(String friend_id)
  {
    for(int i = 0 ; i < members.length ; i++)
      {
         // print(members[i]["user_id"]);
        if(friend_id == members[i]["user_id"]){
          return true ;
        }
      }
    return false ;
  }



  void add_user(String friend_id , var public_key)
  {

    // print(friend_id);
    // print(public_key);

    var new_data = {
      "public_key" : public_key,
      "user_id" : friend_id,
    };
    members.add(new_data) ;


  }


  //formatting for upload to firestore
  Map<String,dynamic>toJson() => {
    "createdAt" : _created_at,
    "createdBy":_created_by,
    "id": _id,
    "members":_members,
    "modifiedAt" : _modified_at,
    "name":_name,
    "recentMessages":recent_messages,
    "type":"2"

  };



}