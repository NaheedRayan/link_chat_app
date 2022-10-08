import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key, this.width, this.height, this.radius})
      : super(key: key);
  final width;
  final height;
  final radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          shape: BoxShape.rectangle,
          color: Colors.black26),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image(
            image: AssetImage('images/profile_pic.png'), fit: BoxFit.fitWidth),
      ),
    );
  }
}
