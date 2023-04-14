import 'package:alitamsniosmobile/Avaibility/searchhighavailibility.dart';
import 'package:alitamsniosmobile/Surveycomplaint/dashboardcompaint.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:alitamsniosmobile/screens/DashboardCheckin.dart';
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
    home: HomeSurvey(),
  );
}

class HomeSurvey extends StatefulWidget {
  const HomeSurvey({Key? key}) : super(key: key);

  @override
  _HomeSurveyState createState() => _HomeSurveyState();
}

class _HomeSurveyState extends State<HomeSurvey> {
  int _currenIndex = 0;
  final tabs = [
    Center(child: Dashboardcomplaint()),
    Center(child: Listdata()),

    // Center(child: Qr()),
    // Center(child: About()),
    // Center(child: profile()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currenIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.teal.shade300),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(
                'List',
                style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.blue.shade200),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.document_scanner),
          //     title: Text(
          //       'High Availibility',
          //       style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //       textAlign: TextAlign.center,
          //     ),
          //     backgroundColor: Colors.blue.shade200),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.qr_code),
          //     title: Text(
          //       'Qr Code',
          //       style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //       textAlign: TextAlign.center,
          //     ),
          //     backgroundColor: Colors.green),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.info),
          //     title: Text(
          //       'About',
          //       style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //       textAlign: TextAlign.center,
          //     ),
          //     backgroundColor: Colors.blueGrey),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person),
          //     title: Text(
          //       'Profile',
          //       style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
          //       textAlign: TextAlign.center,
          //     ),
          //     backgroundColor: Colors.lightBlue.shade200),
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
