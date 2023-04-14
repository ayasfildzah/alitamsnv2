// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/absenijin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? showid;

class Dataabsen {
  final String status;
  final String image;
  final String name;
  final String attendanceout;
  final String nameoff;
  final String attendancein;
  final bool chex;

  Dataabsen({
    required this.status,
    required this.name,
    required this.attendancein,
    required this.attendanceout,
    required this.nameoff,
    required this.image,
    required this.chex,
  });

  factory Dataabsen.fromJson(Map<String, dynamic> json) {
    return Dataabsen(
        status: json['status'],
        name: json['name'],
        attendancein: json['created_at'],
        attendanceout: json['updated_at'],
        nameoff: json['office_name'],
        image: json['image_url'],
        chex: json['chex_out']);
  }
}

class attendances extends StatefulWidget {
  const attendances({Key? key}) : super(key: key);

  @override
  _attendancesState createState() => _attendancesState();
}

class _attendancesState extends State<attendances> {
  int? id;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');

    //image.load(showimage);
    showid = id.toString();
    return id;
  }

  void initState() {
    super.initState();

    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: DefaultTabController(
            length: 8,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  labelColor: Colors.blue.shade100,
                  labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                  labelStyle: TextStyle(fontSize: 8),
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                        text: "WFH",
                        icon: Icon(
                          Icons.home_filled,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Masuk",
                        icon: Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Work Outside",
                        icon: Icon(
                          Icons.laptop,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Survey",
                        icon: Icon(
                          Icons.note,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Sakit",
                        icon: Icon(
                          Icons.sick,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Izin",
                        icon: Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "Cuti",
                        icon: Icon(
                          Icons.list,
                          color: Colors.blue,
                          size: 20,
                        )),
                    Tab(
                        text: "OFF",
                        icon: Icon(
                          Icons.list_alt,
                          color: Colors.blue,
                          size: 20,
                        )),
                  ],
                ),
                automaticallyImplyLeading: false,
                // leading: IconButton(
                //   icon: Icon(Icons.arrow_right),
                //   //  tooltip: "Cancel and Return to List",
                //   onPressed: () {
                //     Navigator.pushReplacement(context,
                //         MaterialPageRoute(builder: (context) => MyDashboard()));
                //   },
                // ),
                title: Row(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       // Navigator.pushReplacement(context,
                    //       //     MaterialPageRoute(builder: (context) => absenijin()));
                    //     },
                    //     icon: Icon(
                    //       Icons.arrow_back_ios,
                    //     )),
                    Text('Attandances'),
                  ],
                ),
                brightness: Brightness.dark,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: 100,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bginput.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  ShowWFH(),
                  ShowMasuk(),
                  ShowWork(),
                  ShowSurvey(),
                  ShowSakit(),
                  ShowIzin(),
                  ShowCuti(),
                  ShowOff(),
                ],
              ),
            ),
          ),
        ));
  }
}

class ShowMasuk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Expanded(
        child: FutureBuilder<List<Dataabsen>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Dataabsen>? data = snapshot.data;
              return ListView.builder(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String img = data[index].image;
                    String stts = data[index].status;
                    String dateout = data[index].attendanceout;
                    String date = data[index].attendancein;
                    String name = data[index].name;
                    String chex = data[index].chex.toString();
                    DateFormat oldFormat =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                    DateFormat newFormat = DateFormat("yyyy-MM-dd");
                    DateFormat jamformat = DateFormat("HH:mm");
                    String dateStr = newFormat.format(oldFormat.parse(date));
                    String showjam = jamformat.format(oldFormat.parse(date));
                    String dateStrout =
                        newFormat.format(oldFormat.parse(dateout));
                    String showjamout =
                        jamformat.format(oldFormat.parse(dateout));
                    String checkout = "Belum Checkout";
                    dateout = checkout;

                    // print("show id2 = " + idd!);
                    if (stts == "Masuk") {
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey.shade200,
                          shadowColor: Colors.grey.shade900,
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        img,
                                      )),
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        5, 10, 30, 10),
                                    child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(children: [
                                          //   const Icon(Icons.person),
                                          //   Text(
                                          //     name,
                                          //     style: TextStyle(
                                          //         color: Colors.black,
                                          //         fontSize: 10,
                                          //         fontFamily: 'OpenSans'),
                                          //     textAlign: TextAlign.left,
                                          //   ),
                                          // ]),
                                          Text(
                                            data[index].nameoff,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          Row(children: [
                                            // const Icon(Icons.fingerprint),
                                            Text(
                                              stts,
                                              style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ]),
                                          Row(children: [
                                            // const Icon(Icons.domain),
                                          ]),
                                          Row(children: [
                                            // const Icon(Icons.lock_clock),
                                            Text(
                                              " Visit : " +
                                                  dateStr +
                                                  " at " +
                                                  showjam,
                                              style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 10,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ]),
                                          Row(children: [
                                            // const Icon(Icons.lock_clock),
                                            if (chex == "null")
                                              Text(
                                                "Out : " + checkout,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              )
                                            else
                                              Text(
                                                "Out : " +
                                                    dateStrout +
                                                    " out " +
                                                    showjamout,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                          ]),
                                        ])),
                              ]));
                    }
                    // if (dateout == null) {
                    //   return Card(
                    //       margin: const EdgeInsets.only(
                    //           top: 20.0), //color: Colors.white,
                    //       child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             CircleAvatar(
                    //                 radius: 40,
                    //                 backgroundImage: NetworkImage(
                    //                   img,
                    //                 )),
                    //             Container(
                    //                 padding: const EdgeInsets.fromLTRB(
                    //                     30, 10, 30, 10),
                    //                 child: Column(
                    //                     // mainAxisAlignment: MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Row(children: [
                    //                         const Icon(Icons.person),
                    //                         Text(
                    //                           name,
                    //                           style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 10,
                    //                               fontFamily: 'OpenSans'),
                    //                           textAlign: TextAlign.left,
                    //                         ),
                    //                       ]),
                    //                       Row(children: [
                    //                         const Icon(Icons.fingerprint),
                    //                         Text(
                    //                           stts,
                    //                           style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 10,
                    //                               fontFamily: 'OpenSans'),
                    //                         ),
                    //                       ]),
                    //                       Row(children: [
                    //                         const Icon(Icons.domain),
                    //                         Text(
                    //                           data[index].nameoff,
                    //                           style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 10,
                    //                               fontFamily: 'OpenSans'),
                    //                         ),
                    //                       ]),
                    //                       Row(children: [
                    //                         // const Icon(Icons.lock_clock),
                    //                         Text(
                    //                           " Visit : " +
                    //                               dateStr +
                    //                               " at " +
                    //                               showjam,
                    //                           style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 10,
                    //                               fontFamily: 'OpenSans'),
                    //                         ),
                    //                       ]),
                    //                       Row(children: [
                    //                         // const Icon(Icons.lock_clock),
                    //                         Text(
                    //                           "Out : " + checkout,
                    //                           style: TextStyle(
                    //                               color: Colors.black,
                    //                               fontSize: 10,
                    //                               fontFamily: 'OpenSans'),
                    //                         ),
                    //                       ]),
                    //                     ])),
                    //           ]));
                    // }
                    //
                    else {
                      return Container();
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
    ])));
  }

// void _onTapItem(BuildContext context, Contact post) {
//   Scaffold.of(context).showSnackBar(
//       new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
// }
}

Future<List<Dataabsen>> fetchData() async {
  var jsonResponse = await http
      .get('https://alita.massindo.com/api/v1/attendance_list?user_id=$showid');

  if (jsonResponse.statusCode == 200) {
    final jsonItems =
        json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

    List<Dataabsen> products = jsonItems.map<Dataabsen>((json) {
      return Dataabsen.fromJson(json);
    }).toList();

    //print(jsonItems);
    return products;
  } else {
    throw Exception('Failed to load dataabsen from internet');
  }
}

class ShowWFH extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Expanded(
        child: FutureBuilder<List<Dataabsen>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Dataabsen>? data = snapshot.data;
              return ListView.builder(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String img = data[index].image;
                    String stts = data[index].status;
                    String dateout = data[index].attendanceout;
                    String date = data[index].attendancein;
                    String name = data[index].name;
                    String office = data[index].nameoff;
                    String chex = data[index].chex.toString();
                    String checkout = " Belum Checkout ";
                    DateFormat oldFormat =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                    DateFormat newFormat = DateFormat("yyyy-MM-dd");
                    DateFormat jamformat = DateFormat("HH:mm");
                    String dateStr = newFormat.format(oldFormat.parse(date));
                    String showjam = jamformat.format(oldFormat.parse(date));
                    String dateStrout =
                        newFormat.format(oldFormat.parse(dateout));
                    String showjamout =
                        jamformat.format(oldFormat.parse(dateout));

                    // print("show id2 = " + idd!);
                    if (stts == "WFH") {
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey.shade200,
                          shadowColor: Colors.grey.shade900,
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        img,
                                      )),
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 30, 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(children: [
                                          //   const Icon(Icons.person),
                                          //   Text(
                                          //     name,
                                          //     style: TextStyle(
                                          //         color: Colors.black,
                                          //         fontSize: 10,
                                          //         fontFamily: 'OpenSans'),
                                          //     textAlign: TextAlign.left,
                                          //   ),
                                          // ]),
                                          Row(children: [
                                            // const Icon(
                                            //   Icons.fingerprint,
                                            //   size: 20,
                                            // ),
                                            Text(
                                              stts,
                                              style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ]),
                                          Row(children: [
                                            // const Icon(Icons.lock_clock),
                                            Text(
                                              " Visit : " +
                                                  dateStr +
                                                  " at " +
                                                  showjam,
                                              style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 12,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ]),
                                          Row(children: [
                                            // const Icon(Icons.lock_clock),
                                            if (chex == "null")
                                              Text(
                                                "Out : " + checkout,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 12,
                                                    fontFamily: 'OpenSans'),
                                              )
                                            else
                                              Text(
                                                "Out : " +
                                                    dateStrout +
                                                    " out " +
                                                    showjamout,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 12,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                          ]),
                                        ])),
                              ]));
                    } else {
                      return Container();
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
    ])));
  }

// void _onTapItem(BuildContext context, Contact post) {
//   Scaffold.of(context).showSnackBar(
//       new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
// }
}

class ShowWork extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      String chex = data[index].chex.toString();
                      String checkout = " Belum Checkout ";
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Work Outside") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                " Visit : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 12,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              if (chex == "null")
                                                Text(
                                                  "Out : " + checkout,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontSize: 12,
                                                      fontFamily: 'OpenSans'),
                                                )
                                              else
                                                Text(
                                                  "Out : " +
                                                      dateStrout +
                                                      " out " +
                                                      showjamout,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontSize: 12,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    ));
  }
}

class ShowSakit extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Sakit") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                " Input : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    ));
  }

// void _onTapItem(BuildContext context, Dataabsen post) {
//   Scaffold.of(context).showSnackBar(
//       new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
// }
}

class ShowOff extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Off") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                " Input : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    ));
  }
}

class ShowSurvey extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Survey") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                " Visit : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                "Out : " +
                                                    dateStrout +
                                                    " out " +
                                                    showjamout,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    );
  }
}

class ShowCuti extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Cuti") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   // const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                " Input : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    ));
  }
}

class ShowIzin extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: <Widget>[
        // IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black54,
        //   iconSize: 30.0,
        //   onPressed: () {
        //     Navigator.pushReplacement(context,
        //         new MaterialPageRoute(builder: (context) => MyDashboard()));
        //   },
        // ),
        Expanded(
          child: FutureBuilder<List<Dataabsen>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataabsen>? data = snapshot.data;
                return ListView.builder(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 100.0),
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String img = data[index].image;
                      String stts = data[index].status;
                      String dateout = data[index].attendanceout;
                      String date = data[index].attendancein;
                      String name = data[index].name;
                      String office = data[index].nameoff;
                      DateFormat oldFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                      DateFormat newFormat = DateFormat("yyyy-MM-dd");
                      DateFormat jamformat = DateFormat("HH:mm");
                      String dateStr = newFormat.format(oldFormat.parse(date));
                      String showjam = jamformat.format(oldFormat.parse(date));
                      String dateStrout =
                          newFormat.format(oldFormat.parse(dateout));
                      String showjamout =
                          jamformat.format(oldFormat.parse(dateout));
                      // print("show id2 = " + idd!);
                      if (stts == "Ijin") {
                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.shade900,
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          img,
                                        )),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(children: [
                                            //   const Icon(Icons.person),
                                            //   Text(
                                            //     name,
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 10,
                                            //         fontFamily: 'OpenSans'),
                                            //     textAlign: TextAlign.left,
                                            //   ),
                                            // ]),
                                            Row(children: [
                                              // const Icon(Icons.fingerprint),
                                              Text(
                                                stts,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                            Row(children: [
                                              // const Icon(Icons.lock_clock),
                                              Text(
                                                "Input : " +
                                                    dateStr +
                                                    " at " +
                                                    showjam,
                                                style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 10,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                            ]),
                                          ])),
                                ]));
                      } else {
                        return Container();
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
      ]),
    ));
  }
}
