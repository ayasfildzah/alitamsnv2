import 'package:alitamsniosmobile/Avaibility/searchallavailibility.dart';
import 'package:alitamsniosmobile/Avaibility/searchbyarea.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/list/attendances.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;

class menuavailibility extends StatefulWidget {
  const menuavailibility({Key? key}) : super(key: key);

  @override
  _menuavailibilityState createState() => _menuavailibilityState();
}

class _menuavailibilityState extends State<menuavailibility> {
  Color primaryColor = Colors.teal.shade300;
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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   //  tooltip: "Cancel and Return to List",
        //   onPressed: () {
        //     Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (context) => MyDashboard()));
        //   },
        // ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        title: Text("Cek Availability"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(120)),
              gradient: LinearGradient(
                  colors: [Colors.teal.shade200, Colors.green.shade200],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
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
                child: Text('Availability Menu',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.teal.shade600.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                child: Text('Search by area - product type and Complite filter',
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
                  height: 400.0,
                  decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 0.3),
                            blurRadius: 15.0)
                      ]),
                  child: Row(children: [
                    Expanded(
                      child: Column(
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
                                                        Searchbyarea()));
                                          },
                                          child: Container(
                                            // alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 10),
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.teal.shade100,
                                              child: Icon(Icons.manage_search,
                                                  size: 30,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Availability by Area-Type",
                                            style: TextStyle(
                                                fontSize: 12,
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
                                                        Searchallavailibility()));
                                          },
                                          child: Container(
                                            // alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 10),
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  Colors.teal.shade100,
                                              child: Icon(Icons.search_sharp,
                                                  size: 30,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Availability Search",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'OpenSans'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.all(5.0),
                                //   child: Container(
                                //     width: 120,
                                //     height: 150,
                                //     child: Wrap(
                                //       children: <Widget>[
                                //         FlatButton(
                                //           onPressed: () {
                                //             // Navigator.pushReplacement(
                                //             //     context,
                                //             //     new MaterialPageRoute(
                                //             //         builder: (context) =>
                                //             //             pilihlokasi()));
                                //           },
                                //           child: Container(
                                //             // alignment: Alignment.center,
                                //             padding: EdgeInsets.only(top: 10),
                                //             child: CircleAvatar(
                                //               radius: 40,
                                //               backgroundColor: Colors.teal.shade100,
                                //               child: Icon(Icons.document_scanner,
                                //                   size: 30, color: Colors.black),
                                //             ),
                                //           ),
                                //         ),
                                //         ListTile(
                                //           title: Text(
                                //             "High Availability",
                                //             style: TextStyle(
                                //                 fontSize: 14,
                                //                 fontFamily: 'OpenSans'),
                                //             textAlign: TextAlign.center,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
