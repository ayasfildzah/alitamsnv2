import 'package:alitamsniosmobile/Screendone/historySp.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:alitamsniosmobile/list/lisitvisitlog.dart';
import 'package:alitamsniosmobile/list/listcheckdisplay.dart';
import 'package:alitamsniosmobile/pages/checkindone.dart';
import 'package:alitamsniosmobile/screens/menuavailability.dart';
import 'package:alitamsniosmobile/screens/menucomplaint.dart';
import 'package:alitamsniosmobile/screens/menusales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;

class Listdata extends StatefulWidget {
  const Listdata({Key? key}) : super(key: key);

  @override
  _ListdataState createState() => _ListdataState();
}

class _ListdataState extends State<Listdata> {
  Color primaryColor = Color(0xff486493);
  late SharedPreferences sharedPreferences;
  String username = '';
  String showimage = '';
  String showno = '';
  var now = new DateTime.now();

  // final String url =
  //     'https://alita.massindo.com//uploads/user/image/382/pp.jpeg';
  late Image image;
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('phone')!;

    setState(() {
      finalname = username;
    });
    //image.load(showimage);
    print(finalname);
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            width: MediaQuery.of(context).size.width / 1,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(30, 0, 0, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('List Dashboard'),
                Text(
                  'Berikut list data yang sudah di input oleh, ' +
                      ' ' +
                      '$finalname',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 10.0),
                ),
              ],
            ),
          ),
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 150,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bginput.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
              child: Container(
                width: double.infinity,
                child: Row(children: [
                  Expanded(
                    child: Column(children: <Widget>[
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: EdgeInsets.only(
                      //             left: 25.0, right: 25.0, top: 30.0),
                      //         child: Text(
                      //           'Menu List Option',
                      //           style: TextStyle(
                      //               color: Colors.black.withOpacity(0.7),
                      //               fontSize: 20.0,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              // width: 120,
                              // height: 150,
                              child: Wrap(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  historySp()));
                                    },
                                    child: Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/orderdelivery.png',
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.center,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "History SP Saya",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              child: Wrap(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  listvisitlog()));
                                    },
                                    child: Container(
                                        // alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/log.png',
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.center,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Visit Log",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Wrap(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                menucomplaint()));
                                  },
                                  child: Container(
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/badreview.png',
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Complaint",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Wrap(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                listcheckdisplay()));
                                  },
                                  child: Container(
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/bedd.png',
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Display",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Wrap(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => menusales()));
                                  },
                                  child: Container(
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/product.png',
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Check Sales Order",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
