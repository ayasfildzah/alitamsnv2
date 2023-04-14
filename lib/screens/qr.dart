import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;

class Qr extends StatefulWidget {
  const Qr({Key? key}) : super(key: key);

  @override
  _QrState createState() => _QrState();
}

class _QrState extends State<Qr> {
  late SharedPreferences sharedPreferences;
  int? id;
  String showid = '';

  String qrData = " "; // already generated qr code when the page opens

  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    id = prefs.getInt('id');

    setState(() {
      finalname = id.toString();
    });
    //image.load(showimage);
    qrData = id.toString();
    print("id = " + qrData);
    return id;
  }

  // void getQr() async {

  //       qrData = finalname!;
  //       print("id = " + qrData);

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // qrData = finalname!;
    //print("id = " + finalname);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Generate QR Code',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.teal.shade600.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 70.0,
            ),
            Text(
              "User ID = " + qrData,
              style: TextStyle(fontSize: 20.0),
            ),
            QrImage(
              //plce where the QR Image will be shown
              data: qrData,
            ),
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
