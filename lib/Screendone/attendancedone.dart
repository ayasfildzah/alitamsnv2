import 'dart:async';
import 'dart:convert';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/screens/DashboardCheckin.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Datacheck {
  final String name;
  final String status;
  final String office;
  final String image;
  final bool chex;

  Datacheck(
      {required this.name,
      required this.chex,
      required this.status,
      required this.office,
      required this.image});

  factory Datacheck.fromJson(Map<String, dynamic> json) {
    return Datacheck(
        name: json['name'],
        status: json['status'],
        office: json['created_at'],
        chex: json['chex_out'],
        image: json['image_url']);
  }
}

class attendancedone extends StatefulWidget {
  const attendancedone({Key? key}) : super(key: key);

  @override
  _attendancedoneState createState() => _attendancedoneState();
}

class _attendancedoneState extends State<attendancedone> {
  Future<List<Datacheck>>? futureData;
  int? id;
  String showid = '';

  // startTime() async {
  //   var _duration = new Duration(seconds: 5);
  //   return new Timer(_duration, navigationPage);
  // }

  // void navigationPage() {
  //   Navigator.pushReplacement(
  //       context, new MaterialPageRoute(builder: (context) => MyDashboard()));
  // }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');

    //image.load(showimage);
    showid = id.toString();
    return id;
  }

  Future<List<Datacheck>> fetchDatacheck() async {
    var jsonResponse = await http.get(
        'https://alita.massindogroup.com/api/v1/attendances?user_id=$showid');

    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
      List<Datacheck> usersList = jsonItems.map<Datacheck>((json) {
        return Datacheck.fromJson(json);
      }).toList();

      return usersList;
    } else {
      throw Exception('Failed to load datacheck from internet');
    }
  }

  void initState() {
    super.initState();
    // getCurrentLocation();
    futureData = fetchDatacheck();
    // startTime();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Icon(Icons.logout),
          ],
          backgroundColor: Colors.lightBlueAccent,
          elevation: 50.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.assignment_turned_in),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" Selamat Anda Sudah berhasil Check In !! ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontSize: 12,
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: 300,
                    child: FutureBuilder<List<Datacheck>>(
                      future: fetchDatacheck(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Datacheck>? data = snapshot.data;
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 100),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                String stts = data[index].status;
                                String nma = data[index].name;
                                String img = data[index].image;
                                String datee = data[index].office;
                                String out = data[index].chex.toString();
                                DateFormat oldFormat =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                                DateFormat newFormat = DateFormat("yyyy-MM-dd");
                                DateFormat jamformat = DateFormat("HH:mm");
                                String dateStr =
                                    newFormat.format(oldFormat.parse(datee));
                                String showjam =
                                    jamformat.format(oldFormat.parse(datee));

                                return Card(
                                    color: Colors.white,
                                    child: Column(children: [
                                      // new Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: Image.network(img)),
                                      new Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  title: new Text(nma),
                                                  subtitle: new Text(dateStr +
                                                      " Jam " +
                                                      showjam),
                                                  trailing: new Text(stts),
                                                ),
                                              ]))
                                    ]));
                              });
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
