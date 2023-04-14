import 'package:alitamsniosmobile/login.dart';
import 'package:alitamsniosmobile/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? finalname;
String? showid;
Position? posisition;
String? dateStr;

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  String username = '';
  String showimage = '';
  String showno = '';
  int? id;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String showjam = "";
  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  String email = "";
  late Image image;
  Color mainColor = Color(0xFF54709E);
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();

    getCurrentLocation();
  }

  Future<bool> logout() async {
    // preferences.setBool('login', true);
    final response = await http.delete(
      Uri.parse('https://alita.massindo.com/api/v2/users/sign_out'),
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

  void getCurrentLocation() async {
    posisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lasPosition = await Geolocator.getLastKnownPosition();
    // print(lasPosition);
    lat = '${posisition!.latitude}';
    lng = '${posisition!.longitude}';

    // print('latitude user = ' + lat);
    // print('longitude user = ' + lng);
    setState(() {
      locationMessage = "$posisition";
    });
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url').toString();
    showno = prefs.getString('phone')!;
    id = prefs.getInt('id');
    email = prefs.getString('email')!;

    setState(() {
      finalname = username;
      username = prefs.getString('name')!;
    });
    //image.load(showimage);
    print("show nma = " + username);

    return username;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Drawer(
          child: Container(
            width: 10,
            padding: EdgeInsets.all(20),
            color: Color(0xFF54709E),
            // constraints: BoxConstraints.expand(),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage("assets/report.png"), fit: BoxFit.scaleDown),
            // ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage('$showimage')),
                      // Icon(
                      //   Icons.person,
                      //   color: Colors.white,
                      // ),

                      Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        showno,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 2,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "My Location : ",
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 40,
                                        //color: Colors.white,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Latitude : ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'OpenSans',
                                                color: Colors.white),
                                          ),
                                          Text(
                                            lat,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 40,
                                        //color: Colors.white,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Longitude : ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'OpenSans',
                                                color: Colors.white),
                                          ),
                                          Text(
                                            lng,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                                indent: 0,
                                endIndent: 0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        QrImage(
                                          //plce where the QR Image will be shown
                                          data: '$id',
                                          size: 150,
                                        ),
                                        Text(
                                          "ID = " + id.toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ],
                              ),
                            ])
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 2,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(
                    height: 100.0,
                  ),

                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(
                  //         Icons.notifications,
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       "Notification",
                  //       style: TextStyle(color: Colors.black, fontSize: 14),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     IconButton(
                  //         onPressed: () {},
                  //         icon: Icon(
                  //           Icons.message,
                  //         )),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       "Message",
                  //       style: TextStyle(color: Colors.black, fontSize: 14),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 20),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            preferences.setInt("value", 0);
                            preferences.remove('email');
                            preferences.remove('name');
                            // ignore: deprecated_member_use
                            preferences.commit();
                          });
                          preferences.setBool('login', true);
                          // logout();
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Image.asset(
                          'assets/logout.png',
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("assets/usserr.png"),
                  //         fit: BoxFit.cover),
                  //   ),
                  //   child: Image.asset(
                  //     'assets/logout.png',
                  //     width: 35,
                  //     height: 35,
                  //     alignment: Alignment.center,
                  //   ),
                  // ),
                  // Image.asset(
                  //   'assets/report.png',
                  //   // width: 35,
                  //   // height: 35,
                  //   alignment: Alignment.center,
                  // ),
                ]),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        // flexibleSpace: Container(
        //   padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/report.png"),
        //         fit: BoxFit.cover,
        //         alignment: Alignment.topCenter),
        //   ),
        //   child: Container(
        //       margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        //       height: 50,
        //       width: 250,
        //       decoration: BoxDecoration(
        //           color: mainColor,
        //           borderRadius: BorderRadius.only(
        //             topRight: Radius.circular(30),
        //             bottomRight: Radius.circular(30),
        //           ),
        //           boxShadow: [
        //             BoxShadow(
        //               offset: Offset(0, 5),
        //               blurRadius: 20,
        //               color: Colors.black.withOpacity(0.10),
        //             )
        //           ]),
        //       child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: <Widget>[
        //             Container(
        //               width: 30,
        //               height: 30,
        //               child: CircleAvatar(
        //                   radius: 20,
        //                   backgroundImage: NetworkImage('$showimage')),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Text('My Dashboard',
        //                 style: TextStyle(
        //                     fontFamily: 'OpenSans',
        //                     color: Colors.white,
        //                     fontSize: 18.0)),
        //           ])),
        // ),
      ),
      body: Dashboard(),
    );
  }
}
