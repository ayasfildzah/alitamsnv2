import 'dart:convert';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? idd;
DateTime now = DateTime.now();

class Datacheckout {
  final int id;
  final String image;
  final String name;
  final String user;
  final String nameoff;
  final bool chex;
  final String attendancein;
  final String status;
  final String error;

  Datacheckout(
      {required this.id,
      required this.chex,
      required this.attendancein,
      required this.user,
      required this.name,
      required this.nameoff,
      required this.image,
      required this.status,
      required this.error});

  factory Datacheckout.fromJson(Map<String, dynamic> json) {
    return Datacheckout(
        id: json['id'],
        attendancein: json['attendance_in'],
        name: json['name'],
        user: json['name'],
        nameoff: json['office_name'],
        image: json['image_url'],
        status: json['status'],
        chex: json['chex_out'],
        error: json['error']);
  }
}

class checkoutin extends StatefulWidget {
  @override
  _checkoutinState createState() => _checkoutinState();
}

class _checkoutinState extends State<checkoutin> {
  Future<List<Datacheckout>>? futureData;
  Future<List<Datacheckout>>? futureDatashow;
  String message = "";
  final double circleRadius = 100.0;

  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;

  late SharedPreferences sharedPreferences;
  String username = '';
  int? showid;
  DateTime now = DateTime.now();
  String date = " ";

  String showimage = '';
  String showno = '';
  String KEYStatus = "";
  int? id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    futureData = fetchDatacheck();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('email')!;
    showid = prefs.getInt('id');

    setState(() {
      finalname = username;
      // KEYStatus = prefs.getString("status")!;
    });

    return username;
  }

  Future<List<Datacheckout>> fetchDatacheck() async {
    posisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lasPosition = await Geolocator.getLastKnownPosition();
    print(
        'https://alita.massindo.com/api/v1/attendance_check_out?user_id=$showid&lat=${posisition!.latitude}&long=${posisition!.longitude}');
    String url =
        'https://alita.massindo.com/api/v1/attendance_check_out?user_id=$showid&lat=${posisition!.latitude}&long=${posisition!.longitude}';

    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final jsonItems = json.decode(response.body);
        var res = jsonItems["result"] as List;

        List<Datacheckout> usersList = res.map<Datacheckout>((json) {
          return Datacheckout.fromJson(json);
        }).toList();

        return usersList;
      } else {
        return <Datacheckout>[];
      }
    } on FormatException catch (e) {
      // ignore: avoid_print
      print('error ${e.toString()}');

      throw Exception(e.toString());
    }
  }

  Widget build(BuildContext context) {
    fetchDatacheck();
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        // ignore: unnecessary_new
        child: new Scaffold(
          body: Stack(children: <Widget>[
            Container(
              height: size.height * .8,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/bgatas.png'))),
            ),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black54,
                      iconSize: 30.0,
                      onPressed: () {
                        // SharedPreferences preferences =
                        //     await SharedPreferences.getInstance();
                        // var stts = preferences.getString("status");

                        // preferences.remove('status');
                        // // ignore: deprecated_member_use
                        // preferences.commit();
                        // Navigator.pushReplacement(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => MyDashboard()));
                      },
                    ),
                    Container(
                      //  color: Color(0xffE0E0E0),
                      child: Stack(children: <Widget>[
                        SizedBox(height: 1.0),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 100 / 2.0,
                                ),

                                ///here we create space for the circle avatar to get ut of the box
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0.0, right: 15.0, left: 15.0),
                                  height: 145.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8.0,
                                        offset: Offset(0.0, 5.0),
                                      ),
                                    ],
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 25.0, bottom: 25.0),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: circleRadius / 2,
                                          ),
                                          Text(
                                            username,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            showno,
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black54),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      )),
                                ),
                              ),

                              ///Image Avatar
                              Container(
                                width: circleRadius,
                                height: circleRadius,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 5.0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Center(
                                    child: Container(
                                      child: CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            NetworkImage('$showimage'),
                                      ),

                                      /// replace your image with the Icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(' Apakah Anda Yakin Untuk Check Out ?? ',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.teal.shade600.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0)),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Home()));
                                },
                                child: Text("Tidak"),
                              ),
                            ])),
                    // SizedBox(height: 15.0),
                    Expanded(
                      child: FutureBuilder(
                        future: futureData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Datacheckout>? users =
                                snapshot.data as List<Datacheckout>?;

                            if (users!.isEmpty) {
                              return showError('No Users');
                            }
                            if (users.isNotEmpty) {
                              Checkotshow();
                              return Checkotshow();
                            }
                          }
                          if (snapshot.hasError) {
                            return showError(snapshot.error.toString());
                          }
                          return CircularProgressIndicator.adaptive();
                        },
                      ),
                    ),
                  ]),
            )),
          ]),
        ));
  }
}

Widget showError(message) {
  return Center(
    child: Text('Jarak terlalu Jauh / Anda Sudah Checkout'),
  );
}

class Checkotshow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<List<Datacheckout>>(
                      future: ShowDataout(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Datacheckout>? data = snapshot.data;
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 0),
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                String img = data[index].image;
                                String stts = data[index].status;
                                String out = data[index].chex.toString();
                                idd = data[index].id.toString();
                                String date = data[index].attendancein;
                                // DateFormat oldFormat =
                                //     new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                                // DateFormat newFormat = new DateFormat("yyyy-MM-dd");
                                // DateFormat jamformat = new DateFormat("HH:mm");
                                // String dateStr =
                                //     newFormat.format(oldFormat.parse(date));
                                // String showjam =
                                //     jamformat.format(oldFormat.parse(date));
                                // print("show id2 = " + idd!);
                                if (stts == "Masuk" && out == "null") {
                                  return Card(
                                      //color: Colors.white,
                                      child: Column(children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      img,
                                      width: 120,
                                      height: 120,
                                    ),
                                    Text(
                                      data[index].id.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),

                                    Text(
                                      data[index].user,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Status : " + stts,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      data[index].nameoff,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans'),
                                      textAlign: TextAlign.center,
                                    ),
                                    // Text(
                                    //   "Tgl : " + date,
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontFamily: 'OpenSans'),
                                    //   textAlign: TextAlign.center,
                                    // ),
                                    // Text(
                                    //   "Jam : " + showjam,
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontFamily: 'OpenSans'),
                                    //   textAlign: TextAlign.center,
                                    // ),

                                    MaterialButton(
                                      color: Colors.green.shade100,
                                      onPressed: () {
                                        // SharedPreferences preferences =
                                        //     await SharedPreferences.getInstance();
                                        // var stts = preferences.getString("status");

                                        // preferences.remove('status');
                                        // // ignore: deprecated_member_use
                                        // preferences.commit();

                                        Updatedata(
                                          id: data[index].id.toString(),
                                        );
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => Home()));
                                        // showAlertDialog(context);
                                      },
                                      child: Text("Check Out"),
                                    ),
                                  ]));
                                } else {
                                  return new Container();
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
                ])));
  }

  // ignore: non_constant_identifier_names
  Future<List<Datacheckout>> ShowDataout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    showid = prefs.getInt('id').toString();
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/attendances?user_id=$showid');
    print("https://alita.massindo.com/api/v1/attendances/user_id=$showid");
    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
      List<Datacheckout> usersList = jsonItems.map<Datacheckout>((json) {
        return Datacheckout.fromJson(json);
      }).toList();
      // print(jsonItems);
      return usersList;
    } else {
      throw Exception('Failed to load datacheck from internet');
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Datacheckout>?> Updatedata({required String id}) async {
    var uri = Uri.parse("https://alita.massindo.com/api/v1/attendances/$id");
    print("https://alita.massindo.com/api/v1/attendances/$id");
    var request = http.MultipartRequest("PUT", uri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['attendance[id]'] = id;
    request.fields['attendance[chex_out]'] = "true";
    request.fields['attendance[attendance_out]'] = now.toString();

    var response = await request.send();

    if (response.statusCode == 202) {
      Fluttertoast.showToast(
          msg: "Selamat Anda Sudah Berhasil Check Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
      print("Berhasil checkout");
    } else {
      Text("Gagal Checkout");
    }
  }

  // showAlertDialog(BuildContext context) {
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.pushReplacement(context,
  //           new MaterialPageRoute(builder: (context) => MyDashboard()));
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Selamat"),
  //     content: Text("Anda Sudah Berhasil Check Out, Kembali ke Home ?"),
  //     // actions: [
  //     //   okButton,
  //     // ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
