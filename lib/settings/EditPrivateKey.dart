import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:link_chat_app/main.dart';


class edit_private_key extends StatefulWidget {
  final pri_key;

  const edit_private_key({Key? key, required this.pri_key}) : super(key: key);

  @override
  State<edit_private_key> createState() => _edit_private_keyState();
}

class _edit_private_keyState extends State<edit_private_key> {
  TextEditingController _pri_key = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Update Private Key'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 5.0),
                child: Text("Enter Private Key",
                    style: TextStyle(color: Colors.black26, fontSize: 16)),
              ),
              TextField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  controller: _pri_key,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      child: Text("Update"),
                      onPressed: () async {
                        if (_pri_key.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Field cannot be empty"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          print(_pri_key.text.toString());
                          final storage = new FlutterSecureStorage();
                          await storage.write(key: "pri_key", value: _pri_key.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Updated"),
                            backgroundColor: Colors.green,
                          ));

                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false);

                        }
                      },

                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
