import 'package:alitamsniosmobile/Avaibility/searchhighavailibility.dart';
import 'package:alitamsniosmobile/Navigator/profilenavi.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:alitamsniosmobile/screens/about.dart';
import 'package:alitamsniosmobile/screens/dashboard.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:alitamsniosmobile/screens/profile.dart';
import 'package:alitamsniosmobile/screens/qr.dart';
import 'package:flutter/material.dart';

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyDashboard(),
  );
}

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  int _currenIndex = 0;
  final tabs = [
    const Center(child: ProfileFragment()),
    Center(child: Listdata()),
    Center(child: highavailibility()),
    // Center(child: About()),
    // Center(child: profile()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currenIndex,
        fixedColor: Colors.teal.shade300,
        // backgroundColor: Colors.teal.shade800,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.teal.shade300,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text(
              'List',
              style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.teal.shade300,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            title: Text(
              'High Availibility',
              style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.teal.shade300,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.info),
          //   title: Text(
          //     'About',
          //     style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //     textAlign: TextAlign.center,
          //   ),
          //   backgroundColor: Colors.teal.shade300,
          // ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person),
          //     title: Text(
          //       'Profile',
          //       style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //       textAlign: TextAlign.center,
          //     ),
          //     backgroundColor: Colors.cyan.shade800),
        ],
        onTap: (index) {
          setState(() {
            _currenIndex = index;
          });
        },
      ),
    );
  }
}
