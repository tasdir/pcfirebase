import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter and Firebase'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.red,


      ),
      body: Container(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add , color: Colors.white)
      ),

    );
  }
}
