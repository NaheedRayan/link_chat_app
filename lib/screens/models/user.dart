class user {
  var _displayName;
  var _email;
  var _groups;
  var _photoURL;
  var _public_key;
  var _uid;

  user(this._displayName, this._email, this._groups, this._photoURL,
      this._public_key, this._uid);

  //getter
  get uid => _uid;

  get public_key => _public_key;

  get photoURL => _photoURL;

  get groups => _groups;

  get email => _email;

  get displayName => _displayName;

  //setter

  set uid(value) {
    _uid = value;
  }

  set public_key(value) {
    _public_key = value;
  }

  set photoURL(value) {
    _photoURL = value;
  }

  set groups(value) {
    _groups = value;
  }

  set email(value) {
    _email = value;
  }

  set displayName(value) {
    _displayName = value;
  }


  //checking if group_id exists
  bool does_group_exist(String group_id)
  {
    if(_groups.contains(group_id) == true)
      return true ;
    else return false ;

  }


  // adding group_id to the array list
  void add_groupid(String group_id)
  {
    _groups.add(group_id);
  }


  //formatting for upload to firestore
  Map<String,dynamic>toJson() => {
    "displayName" : _displayName,
    "email":_email,
    "groups":_groups,
    "photoURL":_photoURL,
    "public_key" :_public_key,
    "uid":_uid,

  };
}
