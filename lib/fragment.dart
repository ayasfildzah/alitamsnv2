import 'package:alitamsniosmobile/Avaibility/searchhighavailibility.dart';
import 'package:alitamsniosmobile/Navigator/profilenavi.dart';
import 'package:alitamsniosmobile/Screendone/inputpesanan.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:alitamsniosmobile/screens/about.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:alitamsniosmobile/screens/pilihcustomer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Properties & Variables needed
  Color mainColor = Color(0xff486493);
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    ProfileFragment(),
    Listdata(),
    highavailibility(),
    About(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = ProfileFragment(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: currentTab == 2 ? Colors.blue : mainColor,
          child: Icon(Icons.home),
          onPressed: () {
            // setState(() {
            //   currentScreen =
            //       Inputpesan(); // if user taps on this dashboard tab will be active
            //   currentTab = 2;
            // });
            // Navigator.push(context,
            //     new MaterialPageRoute(builder: (context) => pilihcustomer()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10.0,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: kBottomNavigationBarHeight,
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 30,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                ProfileFragment(); // if user taps on this dashboard tab will be active
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              color: currentTab == 0
                                  ? Colors.blue
                                  : Colors.white70,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                  color: currentTab == 0
                                      ? Colors.blue
                                      : Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'OpenSans'),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                highavailibility(); // if user taps on this dashboard tab will be active
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.app_registration,
                              color: currentTab == 1
                                  ? Colors.blue
                                  : Colors.white70,
                            ),
                            Text(
                              'High Availability',
                              style: TextStyle(
                                  color: currentTab == 1
                                      ? Colors.blue
                                      : Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'OpenSans'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // Right Tab bar icons

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                attendances(); // if user taps on this dashboard tab will be active
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.app_blocking,
                              color: currentTab == 3
                                  ? Colors.blue
                                  : Colors.white70,
                            ),
                            Text(
                              'Attendances',
                              style: TextStyle(
                                  color: currentTab == 3
                                      ? Colors.blue
                                      : Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'OpenSans'),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Listdata(); // if user taps on this dashboard tab will be active
                            currentTab = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.list,
                              color: currentTab == 4
                                  ? Colors.teal.shade300
                                  : Colors.white70,
                            ),
                            Text(
                              'List',
                              style: TextStyle(
                                  color: currentTab == 4
                                      ? Colors.teal.shade300
                                      : Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'OpenSans'),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
