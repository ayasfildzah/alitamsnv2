import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:alitamsniosmobile/list/listcomplaincus.dart';
import 'package:alitamsniosmobile/list/listcomplaintsurvey.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;

class menucomplaint extends StatefulWidget {
  const menucomplaint({Key? key}) : super(key: key);

  @override
  _menucomplaintState createState() => _menucomplaintState();
}

class _menucomplaintState extends State<menucomplaint> {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Complaint', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          ],
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 120,
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bginput.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text('Complaint Menu',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                child: Text('History Customer Complaints and Survey Schedule',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                child: Container(
                  width: double.infinity,
                  height: 550.0,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 0.3),
                            blurRadius: 15.0)
                      ]),
                  child: Row(children: [
                    Expanded(
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 30.0),
                                child: Text(
                                  'Menu List Option',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                width: 120,
                                height: 150,
                                child: Wrap(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ListComplaintCust()));
                                      },
                                      child: Container(
                                        // alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.manage_search,
                                              size: 30, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Customer Complaints",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'OpenSans'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                width: 120,
                                height: 150,
                                child: Wrap(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ListComplaint()));
                                      },
                                      child: Container(
                                        // alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.search_sharp,
                                              size: 30, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Survey Schedule",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'OpenSans'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                width: 120,
                                height: 150,
                                child: Wrap(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     new MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             pilihlokasi()));
                                      },
                                      child: Container(
                                        // alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.document_scanner,
                                              size: 30, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        "History",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'OpenSans'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }
}
