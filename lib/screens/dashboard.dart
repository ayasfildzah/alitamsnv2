import 'dart:convert';
import 'package:alitamsniosmobile/Screendone/atasanapproval.dart';
import 'package:alitamsniosmobile/Screendone/shownotif.dart';
import 'package:alitamsniosmobile/Surveycomplaint/complaintin.dart';
import 'package:alitamsniosmobile/WFH/wfh.dart';
import 'package:alitamsniosmobile/Workout/workoutside.dart';
import 'package:alitamsniosmobile/login.dart';
import 'package:alitamsniosmobile/model/complaintmodel.dart';
// import 'package:alitaiosmobile/pages/complaintin.dart';
import 'package:alitamsniosmobile/pages/formcuti.dart';
import 'package:alitamsniosmobile/pages/formijin.dart';
import 'package:alitamsniosmobile/pages/formoff.dart';
import 'package:alitamsniosmobile/pages/formsakit.dart';
import 'package:alitamsniosmobile/pages/pilihlokasi.dart';
// import 'package:alitaiosmobile/pages/wfh.dart';
// import 'package:alitaiosmobile/pages/workoutside.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? finalname;
String? showid;

class Dataloc {
  final String status;
  final String code;
  final int total;

  Dataloc({required this.status, required this.code, required this.total});

  factory Dataloc.fromJson(Map<String, dynamic> json) {
    return Dataloc(
      status: json['status'],
      total: json['total'],
      code: json['name'],
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color primaryColor = Color(0xff486493);
  late SharedPreferences sharedPreferences;
  List<Dataloc> detail = [];
  String username = '';
  String showimage = '';
  String showno = '';
  int? id;
  int _count = 1;
  String nosp = '';
  // final String url =
  //     'https://alita.massindo.com//uploads/user/image/382/pp.jpeg';
  late Image image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
  }

  Future<List<Dataloc>> showdetails() async {
    var jsonResponse =
        await http.get('https://alita.massindogroup.com/api/v1/brands');
    if (jsonResponse.statusCode == 200) {
      var data = json.decode(jsonResponse.body);
      var rest = data["result"] as List;
      // var filter;
      // filter = rest.where((val) =>
      //     val["name"] == no);

      detail = rest
          .map<Dataloc>((parsedJson) => Dataloc.fromJson(parsedJson))
          .toList();
      // print(filteredList);
      return detail;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<bool> logout() async {
    // preferences.setBool('login', true);
    final response = await http.delete(
      Uri.parse('https://alita.massindo.com/api/v1/users/sign_out'),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 204) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      print("sukses");
      print(response.statusCode);
      return true;
    } else {
      return false;
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url').toString();
    showno = prefs.getString('phone')!;
    id = prefs.getInt('id');

    setState(() {
      finalname = username;
      username = prefs.getString('name')!;
    });
    //image.load(showimage);
    print("show nma = " + username);
    showid = id.toString();
    return username;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("show id = " + id.toString());
    return WillPopScope(
      onWillPop: () async => false,
      // ignore: unnecessary_new
      child: new Scaffold(
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            Stack(children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/report.png"), fit: BoxFit.fill),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(10),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 5),
                                      blurRadius: 20,
                                      color: Colors.black.withOpacity(0.10),
                                    )
                                  ]),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage('$showimage')),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('My Dashboard',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                  ])),
                          SizedBox(
                            width: 50,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.mail_outline, size: 25)),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 0, top: 0, bottom: 10),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(15),
                              // ),
                              // height: 100,
                              // width: 45,
                              child: IconButton(
                                icon: Stack(children: <Widget>[
                                  Container(
                                      height: 0,
                                      child: FutureBuilder<List<Dataloc>>(
                                        future: showdetails(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<Dataloc>? details =
                                                snapshot.data;
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                // padding: EdgeInsets.only(top: 20),
                                                itemCount: 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int playerIndex) {
                                                  final nDataList =
                                                      details![playerIndex];
                                                  nosp = details.first.code;
                                                  print("code =" + nosp);

                                                  return Column();
                                                });
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}");
                                          }
                                          // By default show a loading spinner.
                                          return CircularProgressIndicator
                                              .adaptive();
                                        },
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => aproval(
                                        //             // invoice: widget.invoice,
                                        //             // pemilik: toString(),
                                        //             // alamat: toString(),
                                        //             nomorsp: nosp)));

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             shownotif()));
                                      },
                                      icon: Icon(
                                          Icons.notifications_none_outlined,
                                          size: 25,
                                          color: Colors.black87)),
                                  // new Positioned(
                                  //   // draw a red marble
                                  //   top: 5.0,
                                  //   right: 0.0,
                                  //   left: 15,
                                  //   bottom: 10,
                                  //   child:
                                  //       // new Icon(Icons.brightness_1,
                                  //       //     size: 25, color: Color(0xFFFF4545)),
                                  //       Container(
                                  //     width: 50,
                                  //     height: 50,
                                  //     padding: EdgeInsets.all(2),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.all(
                                  //         Radius.circular(20),
                                  //       ),
                                  //       color: Color(0xFFFF4545),
                                  //     ),
                                  //     // child: Text("1",
                                  //     //     style: TextStyle(
                                  //     //         fontSize: 10,
                                  //     //         color: Colors.white),
                                  //     //     textAlign: TextAlign.center),
                                  //   ),
                                  // )
                                ]),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          // width: double.infinity,
                          padding:
                              EdgeInsets.only(left: 5, top: 10, bottom: 10),
                          height: MediaQuery.of(context).size.height / 2.3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0.0, 0.3),
                                    blurRadius: 10.0)
                              ]),

                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: 80.0, top: 1.0),
                                child: Text(
                                  'Total absen yang masuk bulan ini',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  MyWidget(),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topRight,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 1),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 200,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      topLeft:
                                                          Radius.circular(30),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          offset:
                                                              Offset(0.2, 0.5),
                                                          blurRadius: 10.0)
                                                    ]),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          pilihlokasi()));
                                                        },
                                                        child: Image.asset(
                                                          'assets/checkin.png',
                                                          width: 35,
                                                          height: 35,
                                                          alignment:
                                                              Alignment.center,
                                                        )),
                                                    Text(
                                                      "Check In",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'OpenSans',
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      topLeft:
                                                          Radius.circular(30),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          offset:
                                                              Offset(0.2, 0.5),
                                                          blurRadius: 10.0)
                                                    ]),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WFH()));
                                                      },
                                                      child: Image.asset(
                                                        'assets/wfh.png',
                                                        width: 35,
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                    Text(
                                                      "WFH",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'OpenSans',
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    // shape: BoxShape.circle,
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      topLeft:
                                                          Radius.circular(30),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          offset:
                                                              Offset(0.2, 0.5),
                                                          blurRadius: 10.0)
                                                    ]),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Complaintcheck()));
                                                      },
                                                      child: Image.asset(
                                                        'assets/survey.png',
                                                        width: 35,
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Survey",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'OpenSans',
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      topLeft:
                                                          Radius.circular(30),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          offset:
                                                              Offset(0.2, 0.5),
                                                          blurRadius: 10.0)
                                                    ]),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Workoutside()));
                                                      },
                                                      child: Image.asset(
                                                        'assets/workout.png',
                                                        width: 35,
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Work Out Side",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'OpenSans',
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   height: size.height * 0.10 - 20,
                      //   decoration: BoxDecoration(
                      //       color: primaryColor,
                      //       borderRadius: BorderRadius.only(
                      //           bottomLeft: Radius.circular(30),
                      //           bottomRight: Radius.circular(30))),
                      // ),
                      // Positioned(
                      //     bottom: 30,
                      //     left: 0,
                      //     right: 0,
                      //     child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 20),
                      //         padding: EdgeInsets.all(10),
                      //         height: 50,
                      //         decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(20),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 offset: Offset(0, 5),
                      //                 blurRadius: 20,
                      //                 color: Colors.black.withOpacity(0.10),
                      //               )
                      //             ]),
                      //         child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: <Widget>[
                      //               Container(
                      //                 width: 30,
                      //                 height: 30,
                      //                 child: CircleAvatar(
                      //                     radius: 20,
                      //                     backgroundImage:
                      //                         NetworkImage('$showimage')),
                      //               ),
                      //               SizedBox(
                      //                 width: 10,
                      //               ),
                      //               Text('My Dashboard',
                      //                   style: TextStyle(
                      //                       fontFamily: 'OpenSans',
                      //                       color: Color(0xFF2D365C),
                      //                       fontSize: 18.0)),
                      //             ]))),
                    ]),
              ),
            ]),
            const SizedBox(
              height: 0,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            //   child: Text('My Dashboard',
            //       style: TextStyle(
            //           fontFamily: 'OpenSans',
            //           color: Colors.teal.shade600.withOpacity(0.7),
            //           fontWeight: FontWeight.bold,
            //           fontSize: 24.0)),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            //   child: Row(
            //     //mainAxisAlignment: MainAxisAlignment.center,
            //     //crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       if (showimage == null)
            //         Icon(
            //           Icons.person,
            //           size: 50,
            //         )
            //       else
            //         CircleAvatar(
            //             radius: 32,
            //             backgroundImage: NetworkImage('$showimage')),
            //       SizedBox(
            //         width: 16,
            //       ),
            //       Text(
            //         'Halo, ' + ' ' + '$finalname',
            //         style: TextStyle(
            //           fontFamily: 'OpenSans',
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //         textAlign: TextAlign.left,
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/resume.png"),
                  fit: BoxFit.scaleDown,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 30.0, right: 25.0, top: 20.0),
                    child: Text(
                      'Menu Absensi',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 5.0, right: 5.0, bottom: 30.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                // height: 120,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      height: height * 0.2,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double innerHeight =
                                              constraints.maxHeight;
                                          double innerWidth =
                                              constraints.maxWidth;
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned(
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                      height:
                                                          innerHeight * 0.72,
                                                      width: innerWidth,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900
                                                                    .withOpacity(
                                                                        0.5),
                                                                offset: Offset(
                                                                    0.3, 0.6),
                                                                blurRadius:
                                                                    10.0)
                                                          ]),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          formijin()));
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    'Izin',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "Menu Form Pengajuan Izin",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.white70)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ))),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 35.0,
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/about.png',

                                                        // width: innerWidth * 0.7,
                                                        // fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      height: height * 0.2,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double innerHeight =
                                              constraints.maxHeight;
                                          double innerWidth =
                                              constraints.maxWidth;
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned(
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                      height:
                                                          innerHeight * 0.72,
                                                      width: innerWidth,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900
                                                                    .withOpacity(
                                                                        0.6),
                                                                offset: Offset(
                                                                    0.3, 0.6),
                                                                blurRadius:
                                                                    10.0)
                                                          ]),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          formsakit()));
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    'Sakit',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "Menu Form Pengajuan Izin Sakit",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.white70)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ))),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 30.0,
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/sick.png',

                                                        // width: innerWidth * 0.7,
                                                        // fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      height: height * 0.2,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double innerHeight =
                                              constraints.maxHeight;
                                          double innerWidth =
                                              constraints.maxWidth;
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned(
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                      height:
                                                          innerHeight * 0.72,
                                                      width: innerWidth,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900
                                                                    .withOpacity(
                                                                        0.6),
                                                                offset: Offset(
                                                                    0.3, 0.6),
                                                                blurRadius:
                                                                    10.0)
                                                          ]),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          formcuti()));
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    'Cuti',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "Menu Form Pengajuan Cuti",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.white70)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ))),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 35.0,
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/cuti.png',

                                                        // width: innerWidth * 0.7,
                                                        // fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      height: height * 0.2,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double innerHeight =
                                              constraints.maxHeight;
                                          double innerWidth =
                                              constraints.maxWidth;
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned(
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                      height:
                                                          innerHeight * 0.72,
                                                      width: innerWidth,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900
                                                                    .withOpacity(
                                                                        0.6),
                                                                offset: Offset(
                                                                    0.3, 0.6),
                                                                blurRadius:
                                                                    10.0)
                                                          ]),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          formoff()));
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    'OFF',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "Menu Form Pengajuan Ijin OFF",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.white70)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ))),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 30.0,
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/finsh.png',

                                                        // width: innerWidth * 0.7,
                                                        // fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]))),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 130,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/videocalling.png',
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.phone_android,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchDataWfh(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Column(children: <Widget>[
                        // Icon(
                        //   Icons.home_rounded,
                        //   size: 10,
                        // ),
                        Text(
                          data[index].status,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Total : " + data[index].total.toString(),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.black,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchoutside(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.emoji_transportation,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchsurvey(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.commute,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchCuti(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.note_alt,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                Text("belum ada data");
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchOff(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.person_off,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchIjin(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.info,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Dataloc>>(
            future: fetchsakit(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Dataloc>? data = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(children: <Widget>[
                          // Icon(
                          //   Icons.sick,
                          //   size: 10,
                          // ),
                          Text(
                            data[index].status,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total : " + data[index].total.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]));
                  },
                );
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

  Future<List<Dataloc>> fetchDataWfh() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=WFH');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchData() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Masuk');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchCuti() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Cuti');
    final jsonItems = json.decode(jsonResponse.body);
    var res = jsonItems["result"] as List;
    if (jsonResponse.statusCode == 200) {
      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      Text("belum ada data");
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchOff() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Off');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchIjin() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Ijin');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchoutside() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Work%20Outside');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchsurvey() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Survey');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Dataloc>> fetchsakit() async {
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/attendance_status?user_id=$showid&status=Sakit');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var res = jsonItems["result"] as List;

      List<Dataloc> usersList = res.map<Dataloc>((json) {
        return Dataloc.fromJson(json);
      }).toList();

      return usersList;
      print(usersList);
    } else {
      throw Exception('Failed to load data from internet');
    }
  }
}
