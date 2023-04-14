import 'package:alitamsniosmobile/Navigator/homenavi.dart';
import 'package:alitamsniosmobile/Navigator/profilenavi.dart';
import 'package:alitamsniosmobile/Navigator/settingnavi.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Navigation Drawer',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
String? finalname;

class DrawerItem {
  String title;
  IconData icon;
  Function body;
  DrawerItem(this.title, this.icon, this.body);
}

class MyHomePage extends StatefulWidget {
  // final drawerFragments = [
  //   new DrawerItem("Home", Icons.home, () => new HomeFragment()),
  //   new DrawerItem(
  //       "Profile", Icons.supervised_user_circle, () => new ProfileFragment()),
  //   new DrawerItem("Settings", Icons.settings, () => new SettingsFragment())
  // ];

  // MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedDrawerFragmentIndex = 0;
  String username = "";
  String showimage = "";
  String showno = "";
  int? id;
  String email = "";
  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;

  // _getDrawerFragmentWidgetIndex(int pos) {
  //   if (widget.drawerFragments[pos] != null) {
  //     return widget.drawerFragments[pos].body();
  //   } else {
  //     return new Text("Error");
  //   }
  // }
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

  _onSelectFragment(int index) {
    setState(() => _selectedDrawerFragmentIndex = index);
    Navigator.of(context).pop();
  }

  // Future<bool> logout() async {
  //   // preferences.setBool('login', true);
  //   final response = await http.delete(
  //     Uri.parse('https://alita.massindo.com/api/v2/users/sign_out'),
  //     headers: <String, String>{
  //       "Accept": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 204) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Login()));
  //     print("sukses");
  //     print(response.statusCode);
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    // for (var i = 0; i < widget.drawerFragments.length; i++) {
    //   var d = widget.drawerFragments[i];
    //   drawerOptions.add(new ListTile(
    //     leading: new Icon(d.icon),
    //     title: new Text(d.title),
    //     selected: i == _selectedDrawerFragmentIndex,
    //     onTap: () => _onSelectFragment(i),
    //   ));
    // }

    return Scaffold(
        // appBar: AppBar(
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.menu, color: Colors.black),
        //   //   onPressed: () {
        //   //     Scaffold.of(context).openDrawer();
        //   //   },
        //   // ),

        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   toolbarHeight: 40,
        //   // title: Text(
        //   //   "Alita Mobile",
        //   //   style: TextStyle(
        //   //       fontFamily: 'OpensSans',
        //   //       fontSize: 16,
        //   //       color: Colors.white,
        //   //       fontWeight: FontWeight.w200),
        //   // ),
        //   centerTitle: true,
        // ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.teal.shade300, Colors.teal.shade300],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  currentAccountPicture: CircleAvatar(
                      radius: 32, backgroundImage: NetworkImage('$showimage')),
                  accountName: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  accountEmail: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        email,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width / 1.6,
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Color(0xFF2D365C))),
                  child: Row(
                    children: [
                      Column(children: [
                        QrImage(
                          //plce where the QR Image will be shown
                          data: '$id',
                          size: 100,
                        ),
                        Text(
                          "User ID = " + id.toString(),
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ]),
                      SizedBox(
                        width: 15.0,
                      ),
                      Column(children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/location.png',
                              width: 35,
                              height: 35,
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              lat,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.black,
                                  fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Latitude",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black26),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          children: [
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
                      ])
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 30.0,
                // ),
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
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                      icon: Icon(Icons.logout),
                      color: Colors.black,
                      iconSize: 20.0,
                      onPressed: () async {
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
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: MyDashboard());
  }
}
