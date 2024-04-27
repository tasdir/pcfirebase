import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text('This is the user profile page.Changed it'),
      ),
    );
  }
}
