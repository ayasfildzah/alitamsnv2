// ignore_for_file: avoid_unnecessary_containers

import 'package:alitamsniosmobile/Checkdisplay/adddisplay.dart';
import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/Checkout/checkoutwfh.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/searchdocumentdisplay.dart';
import 'package:alitamsniosmobile/pages/formlaporan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? showid;
String? office;

class Dashboardwfh extends StatefulWidget {
  const Dashboardwfh({Key? key}) : super(key: key);

  @override
  _DashboardwfhState createState() => _DashboardwfhState();
}

class _DashboardwfhState extends State<Dashboardwfh> {
  final double circleRadius = 100.0;
  late SharedPreferences sharedPreferences;
  String username = '';
  String showimage = '';
  String showno = '';
  String KEYStatus = "";
  String no = "";
  String off = " ";
  int? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    read();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('email')!;
    id = prefs.getInt('id');
    no = prefs.getString('phone')!;

    setState(() {
      finalname = username;
      // KEYStatus = prefs.getString("status")!;
    });
    //image.load(showimage);
    showid = id.toString();
    return username;
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    off = prefs.getString("latitude_user")!;
    print("nama = " + off);

    setState(() {
      office = off;
      off = prefs.getString("latitude_user")!;
    });
    return off;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'My Profile',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: CircleAvatar(
            radius: 50,
            child: ClipOval(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage('$showimage'),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 15,
                          ),
                          Text(username,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 15,
                          ),
                          Text(showno,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: 15,
                          ),
                          Text(id.toString(),
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 15,
                          ),
                          Text(no,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width / 1.2,
              //   height: 80,
              //   child: Card(
              //     child: new InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               new MaterialPageRoute(
              //                   builder: (context) => laporan()));
              //         },
              //         child: Wrap(
              //           alignment: WrapAlignment.center,
              //           children: <Widget>[
              //             ListTile(
              //               leading: Image.asset(
              //                 'assets/document.png',
              //                 width: 50,
              //                 height: 50,
              //                 alignment: Alignment.center,
              //               ),
              //               title: Text(
              //                 "Laporan",
              //                 style: TextStyle(
              //                     fontFamily: 'OpenSans',
              //                     color: Colors.blueAccent),
              //               ),
              //               subtitle: Text(
              //                 "Form Laporan Hasil Kunjungan",
              //                 style: TextStyle(
              //                     fontFamily: 'OpenSans',
              //                     fontSize: 11,
              //                     color: Colors.black26),
              //               ),
              //             ),
              //           ],
              //         )),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 180,
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => checkoutwfh()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/hp.png',
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                        ),
                        Text(
                          "Check Out",
                          style: TextStyle(
                              fontFamily: 'OpenSans', color: Colors.blueAccent),
                        ),
                        Text(
                          "Klik Checkout Jika Pekerjaan Sudah Selesai",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 11,
                              color: Colors.black26),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
