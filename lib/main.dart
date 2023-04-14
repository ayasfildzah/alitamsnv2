import 'package:alitamsniosmobile/Avaibility/searchhighavailibility.dart';
import 'package:alitamsniosmobile/Checkout/checkout.dart';
import 'package:alitamsniosmobile/Notif/notification.dart';
import 'package:alitamsniosmobile/Surveycomplaint/surveydone.dart';
import 'package:alitamsniosmobile/WFH/homewfh.dart';
import 'package:alitamsniosmobile/Workout/dashboardworkoutside.dart';
import 'package:alitamsniosmobile/Workout/homeworkout.dart';
import 'package:alitamsniosmobile/Workout/workoutsidedone.dart';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/homecheckin.dart';
import 'package:alitamsniosmobile/Surveycomplaint/homesurvey.dart';
import 'package:alitamsniosmobile/list/listcomplaincus.dart';
import 'package:alitamsniosmobile/login.dart';
import 'package:alitamsniosmobile/pages/checkindone.dart';
import 'package:alitamsniosmobile/pages/formoff.dart';
import 'package:alitamsniosmobile/pages/test.dart';
import 'package:alitamsniosmobile/screens/dashboard.dart';
import 'package:alitamsniosmobile/spalshcreen.dart';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
        primaryColor: Color(0xff0082CD), primaryColorDark: Color(0xff0082CD)),
    home: new Splash(),
  ));
}
