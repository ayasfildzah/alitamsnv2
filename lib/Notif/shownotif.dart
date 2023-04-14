import 'dart:async';
import 'package:alitamsniosmobile/Notif/notification.dart';
import 'package:alitamsniosmobile/Screendone/atasanapproval.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String payload = " ";
  String nosp = "200123456A89";

  Future onSelectNotification(String? payload) async {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: nosp,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Local Notification'),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: showNotification,
          child: new Text(
            'Demo',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails('channel id', 'channel NAME',
        channelDescription: 'description',
        priority: Priority.high,
        importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, 'Pengajuan Discount',
        'Sales mengajukan penambahan discount  ', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //   return NewScreen(
    //     payload: payload,
    //   );
    // }));

    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return aproval(
        nomorsp: '',
        // payload: nosp,
      );
    }));
  }
}
