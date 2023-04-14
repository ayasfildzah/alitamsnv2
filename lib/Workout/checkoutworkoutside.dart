import 'dart:convert';
import 'package:alitamsniosmobile/WFH/dashboardwfh.dart';
import 'package:alitamsniosmobile/Workout/dashboardworkoutside.dart';
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
String? office;
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
        attendancein: json['created_at'],
        name: json['name'],
        user: json['name'],
        nameoff: json['office_name'],
        image: json['image_url'],
        status: json['status'],
        chex: json['chex_out'],
        error: json['error']);
  }
}

class checkoutworkoutside extends StatefulWidget {
  @override
  _checkoutworkoutsideState createState() => _checkoutworkoutsideState();
}

class _checkoutworkoutsideState extends State<checkoutworkoutside> {
  Future<List<Datacheckout>>? futureData;
  Future<List<Datacheckout>>? futureDatashow;
  String message = "";

  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;
  String off = "";
  late SharedPreferences sharedPreferences;
  String username = '';
  int? showid;
  DateTime now = DateTime.now();
  String date = " ";

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showid = prefs.getInt('id');
  }

  Future<List<Datacheckout>> fetchDatacheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showid = prefs.getInt('id');
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/attendances?user_id=$showid');

    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
      List<Datacheckout> usersList = jsonItems.map<Datacheckout>((json) {
        return Datacheckout.fromJson(json);
      }).toList();
      print(jsonItems);
      return usersList;
    } else {
      throw Exception('Failed to load datacheck from internet');
    }
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    off = prefs.getString("longitude_user")!;
    print("nama = " + off);

    setState(() {
      office = off;
    });
    return office;
  }

  // static List<Datacheckout> parseUsers(String responseBody) {

  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed
  //       .map<Datacheckout>((json) => Datacheckout.fromJson(json))
  //       .toList();
  // }
  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    fetchDatacheck();
    getStringValuesSF();
    // read();

    //futureDatashow = ShowDataout();
  }

  @override
  Widget build(BuildContext context) {
    fetchDatacheck();
    date = now.toString();
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0, right: 25.0, left: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black54,
                        iconSize: 30.0,
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     new MaterialPageRoute(
                          //         builder: (context) => MyDashboard()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text(' Apakah Anda Yakin Untuk Check Out ?? ',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.teal.shade600.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0)),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        Dashboardworkoutside()));
                          },
                          child: Text("Tidak"),
                        ),
                      ])),
              // SizedBox(height: 15.0),
              Expanded(
                child: FutureBuilder<List<Datacheckout>>(
                  future: fetchDatacheck(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Datacheckout>? data = snapshot.data;

                      return ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: data!.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            String img = data[index].image;
                            String stts = data[index].status;
                            String out = data[index].chex.toString();
                            idd = data[index].id.toString();
                            String date = data[index].attendancein;
                            DateFormat oldFormat =
                                new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                            DateFormat newFormat = new DateFormat("yyyy-MM-dd");
                            DateFormat jamformat = new DateFormat("HH:mm");
                            String dateStr =
                                newFormat.format(oldFormat.parse(date));
                            String showjam =
                                jamformat.format(oldFormat.parse(date));
                            // print("show id2 = " + idd!);
                            if (stts == "Work Outside" && out == "null") {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1,
                                  //color: Colors.white,
                                  child: Column(children: [
                                    new Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(data[index].image),
                                      width: 150,
                                      height: 150,
                                    ),
                                    new Container(
                                        child: ListTile(
                                      title: new Text(
                                        data[index].id.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 5),
                                      ),
                                    )),
                                    new Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 20),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
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
                                              // Text(
                                              //   data[index].nameoff,
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontFamily: 'OpenSans'),
                                              //   textAlign: TextAlign.center,
                                              // ),
                                              Text(
                                                "Tgl : " + date,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'OpenSans'),
                                                textAlign: TextAlign.center,
                                              ),
                                              // Text(
                                              //   "Jam : " + showjam,
                                              //   style: TextStyle(
                                              //       color: Colors.black,
                                              //       fontFamily: 'OpenSans'),
                                              //   textAlign: TextAlign.center,
                                              // ),
                                            ])),
                                    MaterialButton(
                                      color: Colors.green.shade100,
                                      onPressed: () async {
                                        Updatedata(
                                          id: data[index].id.toString(),
                                        );
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();

                                        preferences.setInt("value", 0);
                                        preferences.remove("longitude_user");
                                        preferences.remove(office!);
                                        showAlertDialog(context);
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
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ]))));
  }

  Widget showError(message) {
    return Center(
      child: Text('Jarak terlalu Jauh / Anda Sudah Checkout'),
    );
  }

  // ignore: non_constant_identifier_names
  Future<List<Datacheckout>?> Updatedata({required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    office = prefs.getString("longitude_user")!;
    print("nama = " + office.toString());

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
      prefs.commit();
      prefs.clear();
      prefs.remove("longitude_user");

      prefs.setBool('login', true);

      Fluttertoast.showToast(
          msg: "Selamat Anda Sudah Berhasil Check Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
    } else {
      Text("Berhasil Checkout");
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => MyDashboard()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Selamat"),
      content: Text("Anda Sudah Berhasil Check Out, Kembali ke Home ?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
