import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/screens/DashboardCheckin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? showid;

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  final double circleRadius = 100.0;
  late SharedPreferences sharedPreferences;
  String username = '';
  String showimage = '';
  String showno = '';
  String phone = '';
  String KEYStatus = "";
  String last = '';
  int? id;
  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;
  String dateStr = '';
  String showjam = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    getCurrentLocation();
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
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('email')!;
    id = prefs.getInt('id');
    phone = prefs.getString('phone')!;
    // last = prefs.getString('last_sign_in_with_authy').toString();
    // DateFormat oldFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    // DateFormat newFormat = DateFormat("yyyy-MM-dd");
    // DateFormat jamformat = DateFormat("HH:mm");
    // dateStr = newFormat.format(oldFormat.parse(last));
    // showjam = jamformat.format(oldFormat.parse(last));
    // if (last == "null") {
    //   String notif = "Not Record";
    //   dateStr = notif;
    //   showjam = notif;
    // }

    // setState(() {
    //   finalname = username;
    //   KEYStatus = prefs.getString("status")!;
    // });
    //image.load(showimage);
    showid = id.toString();
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.cyan.shade800,
                toolbarHeight: 210,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Profile",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(showimage),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.person),
                              SizedBox(width: 10),
                              Text(
                                username,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ]),
                            Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(width: 10),
                                Text(
                                  showno,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone_android),
                                SizedBox(width: 10),
                                Text(
                                  '+62' + phone,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )),
            body: Container(
                child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                width: 1.0, color: Colors.cyan.shade800)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              child: Image.asset(
                                'assets/location.png',
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              child: Text(
                                lat,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.black,
                                    fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Latitude",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'OpenSans',
                                    color: Colors.black26),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                width: 1.0, color: Colors.cyan.shade800)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              child: Image.asset(
                                'assets/locations.png',
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              child: Text(lng,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.black,
                                      fontSize: 8),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              child: Text(
                                "Longitude",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'OpenSans',
                                    color: Colors.black26),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Generate QR Code',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Colors.teal.shade600.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "User ID = " + id.toString(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                          QrImage(
                            //plce where the QR Image will be shown
                            data: '$id',
                            size: 180,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ))));
  }
}
