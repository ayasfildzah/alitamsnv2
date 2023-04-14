// ignore_for_file: avoid_unnecessary_containers

import 'package:alitamsniosmobile/Checkdisplay/adddisplay.dart';
import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/searchdocumentdisplay.dart';
import 'package:alitamsniosmobile/pages/formlaporan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? showid;
String? office;

class Dashboardtwo extends StatefulWidget {
  const Dashboardtwo({Key? key}) : super(key: key);

  @override
  _DashboardtwoState createState() => _DashboardtwoState();
}

class _DashboardtwoState extends State<Dashboardtwo> {
  final double circleRadius = 100.0;
  late SharedPreferences sharedPreferences;
  String username = '';
  String showimage = '';
  String showno = '';
  String KEYStatus = "";
  String off = "";
  int? id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    read();
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    off = prefs.getString("status")!;
    print("nama = " + off);

    setState(() {
      office = off;
      off = prefs.getString("status")!;
    });
    return off;
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('email')!;
    id = prefs.getInt('id');

    setState(() {
      finalname = username;
      KEYStatus = prefs.getString("status")!;
    });
    //image.load(showimage);
    print(KEYStatus);
    showid = id.toString();
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('$showimage'),
                      ),

                      /// replace your image with the Icon
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.blue.shade600.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    Text(
                      showno,
                      style: TextStyle(fontSize: 10.0, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: Container(
                  width: double.infinity,
                  height: 500.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0.0, 0.3),
                            blurRadius: 15.0)
                      ]),
                  child: Row(children: [
                    Expanded(
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 30.0),
                                child: Text(
                                  'Menu List Option',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 80,
                                child: Card(
                                  child: new InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    laporan()));
                                      },
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Image.asset(
                                              'assets/document.png',
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.center,
                                            ),
                                            title: Text(
                                              "Laporan",
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.blueAccent),
                                            ),
                                            subtitle: Text(
                                              "Form Laporan Hasil Kunjungan",
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 11,
                                                  color: Colors.black26),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 80,
                                  child: Card(
                                    child: new InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    adddisplay()));
                                      },
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Image.asset(
                                              'assets/display.png',
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.center,
                                            ),
                                            title: Text(
                                              "Display",
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.blueAccent),
                                            ),
                                            subtitle: Text(
                                              "Form Check Display Kunjungan",
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 11,
                                                  color: Colors.black26),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 80,
                                  child: Card(
                                    child: new InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    documnetdisplay()));
                                      },
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          ListTile(
                                              leading: Image.asset(
                                                'assets/faill.png',
                                                width: 50,
                                                height: 50,
                                                alignment: Alignment.center,
                                              ),
                                              title: Text(
                                                "Document Display",
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    color: Colors.blueAccent),
                                              ),
                                              subtitle: Text(
                                                "Form Document Display",
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 11,
                                                    color: Colors.black26),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 80,
                                child: Card(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Image.asset(
                                          'assets/hp.png',
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                        ),
                                        title: Text(
                                          "Check Out",
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.blueAccent),
                                        ),
                                        subtitle: Text(
                                          "Klik Checkout Jika Pekerjaan Sudah Selesai",
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 11,
                                              color: Colors.black26),
                                        ),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      checkout()));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ]),
                    )
                  ])),
            ),
          ]),
        )));
  }
}
