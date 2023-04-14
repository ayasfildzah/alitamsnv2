import 'package:alitamsniosmobile/fragment.dart';
// import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/login.dart';
// import 'package:alitaiosmobile/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  var value;
  getPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("name");

      runApp(MaterialApp(
        home: value == null ? Login() : Home(),
      ));
    });
  }

  // @override
  // void initState() {
  //   // ignore: todo
  //   // TODO: implement initState
  //   super.initState();
  //   getPref();
  // }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Login(),
      title: new Text('Alita',
          style: new TextStyle(
              fontSize: 60.0,
              fontWeight: FontWeight.w100,
              color: Colors.black)),
      image: new Image.asset(
        'assets/timerr.png',
      ),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 180.0,
      // backgroundColor: Color(0xff486493),
      // loaderColor: Colors.red,
      loadingText: Text(
        "Aplikasi Absen Online",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
