import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First App"),
      ),
      body: Center(
        child: FlareActor("assets/bubble.flr",
        animation: "phone_sway",
        fit: BoxFit.contain)
      )
    );
  }
}