// ignore_for_file: avoid_unnecessary_containers

import 'package:alitamsniosmobile/Checkdisplay/adddisplay.dart';
import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/Workout/checkoutworkoutside.dart';
import 'package:alitamsniosmobile/Workout/formlaporanworkout.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/searchdocumentdisplay.dart';
import 'package:alitamsniosmobile/pages/formlaporan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? office;
String? showid;

class Dashboardworkoutside extends StatefulWidget {
  const Dashboardworkoutside({Key? key}) : super(key: key);

  @override
  _DashboardworkoutsideState createState() => _DashboardworkoutsideState();
}

class _DashboardworkoutsideState extends State<Dashboardworkoutside> {
  final double circleRadius = 100.0;
  late SharedPreferences sharedPreferences;
  String username = '';
  String showimage = '';
  String showno = '';
  String KEYStatus = "";
  String no = "";
  String off = "";
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
    off = prefs.getString("longitude_user")!;
    print("nama = " + off);

    setState(() {
      office = off;
    });
    return office;
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
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      width: 135,
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
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      width: 140,
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
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      width: 135,
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
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      width: 140,
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
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 80,
                child: Card(
                  child: new InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => laporanworkoutside()));
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
                              fontFamily: 'OpenSans', color: Colors.blueAccent),
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
                                  builder: (context) => checkoutworkoutside()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
