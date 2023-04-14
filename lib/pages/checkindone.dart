import 'dart:async';
import 'dart:convert';

import 'package:alitamsniosmobile/Checkout/checkoutin.dart';

import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/homecheckin.dart';
import 'package:alitamsniosmobile/screens/DashboardCheckin.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
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
        office: json['office_name'],
        chex: json['chex_out'],
        image: json['image_url']);
  }
}

class checkindone extends StatefulWidget {
  const checkindone({Key? key}) : super(key: key);

  @override
  _checkindoneState createState() => _checkindoneState();
}

class _checkindoneState extends State<checkindone> {
  Future<List<Datacheck>>? futureData;
  int? id;
  String showid = '';
  List<Datacheck> data = [];

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => Homecheckin()));
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');

    //image.load(showimage);
    showid = id.toString();
    return id;
  }

  Future<List<Datacheck>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');
    print('https://alita.massindo.com/api/v1/attendances?user_id=$id');
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/attendances?user_id=$id');

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      // var rest = jsonItems["result"] as List;
      List<Datacheck> products = jsonItems.map<Datacheck>((json) {
        return Datacheck.fromJson(json);
      }).toList();

      //print(jsonItems);
      return products;
    } else {
      throw Exception('Failed to load dataabsen from internet');
    }
  }

  void initState() {
    super.initState();
    // getCurrentLocation();
    futureData = fetchData();
    startTime();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //  tooltip: "Cancel and Return to List",
            onPressed: () {
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => MyDashboard()));
            },
          ),
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 100,
          title: Text(
            "My Attendances",
            style: TextStyle(color: Colors.blue.shade400, fontSize: 24),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                gradient: LinearGradient(
                    colors: [Colors.lightBlue.shade100, Colors.blue.shade300],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 1,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ButtonTheme(
                  //     minWidth: MediaQuery.of(context).size.width / 3,
                  //     height: 60.0,
                  //     child: FlatButton.icon(
                  //       icon: Icon(Icons.forward),
                  //       color: Colors.white,
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => Dashboardtwo()));
                  //       },
                  //       label: Text(
                  //         "To Dashboard Checkout",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           // decoration: TextDecoration.underline,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //           color: Theme.of(context).accentColor,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: FutureBuilder<List<Datacheck>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Datacheck>? data = snapshot.data;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 20),
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                String stts = data[index].status;
                                String nma = data[index].name;
                                String img = data[index].image;
                                String off = data[index].office;
                                String out = data[index].chex.toString();
                                // print("gambar = " + img);
                                if (stts == "Masuk" && out == "null") {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1,
                                      color: Colors.white,
                                      child: Column(children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            data[index].image,
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                        new Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    title: new Text(nma),
                                                    trailing: new Text(stts),
                                                    subtitle: new Text(off),
                                                  ),
                                                ]))
                                      ]));
                                } else {
                                  return Container();
                                }
                              });
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator.adaptive();
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
