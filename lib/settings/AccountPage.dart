import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:link_chat_app/main.dart';
import 'EditPrivateKey.dart';

class accountpage extends StatefulWidget {
  final username, email, number, public_key;

  const accountpage(
      {Key? key,
      required this.username,
      required this.email,
      required this.number,
      required this.public_key})
      : super(key: key);

  @override
  State<accountpage> createState() =>
      _accountpageState(username, email, number, public_key);
}

class _accountpageState extends State<accountpage> {
  var username, email, number, public_key;

  _accountpageState(this.username, this.email, this.number, this.public_key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: callasync(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text('Profile'),
                centerTitle: true,
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.green.shade100
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.5, 0.9],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              minRadius: 60.0,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    AssetImage('images/profile_pic.png'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          // '${userdata['email']}',
                          "$username",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Email',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '$email',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            'Number',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '$number',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            'Public Key',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${public_key}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            'Private Key',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                '${snapshot.data}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: snapshot.data));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Copied to clipboard")));
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 24.0,
                                    ),
                                    label: Text('Copy'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => edit_private_key(
                                          pri_key: snapshot.data,
                                        ),
                                        fullscreenDialog: true,
                                      ));
                                    },
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.edit,
                                      size: 24.0,
                                    ),
                                    label: Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final storage =
                                          new FlutterSecureStorage();
                                      await storage.write(
                                          key: "pri_key", value: "empty");

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Private Key Deleted"),backgroundColor: Colors.red,));
                                      Navigator.pushAndRemoveUntil(
                                          context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);

                                    },
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.delete_forever,
                                      size: 24.0,
                                    ),
                                    label: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else
            return CircularProgressIndicator();
        });
  }

  callasync() async {
    final storage = new FlutterSecureStorage();
    var pri_key = await storage.read(key: "pri_key");
    return pri_key;
  }
}
