import 'dart:convert';

import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/list/listcheckdisplay.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? finalname;

class display {
  String serialnumber;
  String note;
  String date;
  String imageurl;
  String itemnumber;
  String status;

  display(
      {required this.itemnumber,
      required this.note,
      required this.imageurl,
      required this.serialnumber,
      required this.date,
      required this.status});
  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
        itemnumber: parsedJson["item_number"],
        serialnumber: parsedJson["serial_number"],
        date: parsedJson["created_at"],
        imageurl: parsedJson["image_url"],
        status: parsedJson["status"],
        note: parsedJson["note"]);
  }
}

class checkdisplaydetails extends StatefulWidget {
  int dID;

  checkdisplaydetails({required this.dID});

  @override
  _checkdisplaydetailsState createState() => _checkdisplaydetailsState();
}

class _checkdisplaydetailsState extends State<checkdisplaydetails> {
  String username = '';
  List<display> listmodel = [];
  bool loading = false;
  int? id;

  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    getData();
  }

  Future<Null> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    id = prefs.getInt('id')!;

    setState(() {
      loading = true;
    });

    final responseData = await http.get(
        "https://alita.massindo.com/api/v1/check_display_details?check_display_id=${widget.dID}");
    print(
        "https://alita.massindo.com/api/v1/check_display_details?check_display_id=${widget.dID}");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);

      print(data);
      setState(() {
        for (Map<String, dynamic> i in data) {
          listmodel.add(display.fromJson(i));
        }
        loading = false;
      });
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    setState(() {
      finalname = username;
    });
    return finalname;
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => listcheckdisplay()));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check Display yang di Input oleh ',
                          style: TextStyle(fontSize: 12)),
                      Text('$username', style: TextStyle(fontSize: 12)),
                    ],
                  ),
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
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: listmodel.length,
                        itemBuilder: (context, i) {
                          final nDataList = listmodel[i];
                          String credate = nDataList.date;
                          DateFormat oldFormat =
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                          DateFormat newFormat = DateFormat("yyyy-MM-dd");
                          DateFormat jamformat = DateFormat("HH:mm");
                          String dateStr =
                              newFormat.format(oldFormat.parse(credate));
                          String showjam =
                              jamformat.format(oldFormat.parse(credate));
                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 100,
                                      padding: EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: PhotoView(
                                          imageProvider:
                                              NetworkImage(nDataList.imageurl),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      width: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Serial Number : ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Item Number :",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Tanggal : ",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Note : ",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Status : ",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nDataList.serialnumber.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            nDataList.itemnumber.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                          Text(
                                            dateStr + " Jam " + showjam,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            nDataList.note,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                          Text(
                                            nDataList.status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
