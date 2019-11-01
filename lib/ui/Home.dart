import 'package:flutter/material.dart';
import 'package:keep_notes/ui/Body.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keep Notes"),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),

      body: Body(),
    );
  }
}
