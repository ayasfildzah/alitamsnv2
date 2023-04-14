import 'dart:convert';

import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? finalname;

class display {
  Place placename;
  Dept deptname;
  String note;
  String date;
  String imageurl;

  display({
    required this.placename,
    required this.note,
    required this.imageurl,
    required this.deptname,
    required this.date,
  });
  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
        placename: Place.fromJson(parsedJson["work_place"]),
        deptname: Dept.fromJson(parsedJson["departement"]),
        date: parsedJson["created_at"],
        imageurl: parsedJson["image_url"],
        note: parsedJson["note"]);
  }
}

class Place {
  String placename;
  String placeaddrsl;

  Place({required this.placename, required this.placeaddrsl});
  factory Place.fromJson(Map<String, dynamic> json) => Place(
      placename: json["work_place_name"],
      placeaddrsl: json["work_place_address"]);
  Map<String, dynamic> toJson() => {
        "work_place_name": placename,
        "work_place_address": placeaddrsl,
      };
}

class Dept {
  String Deptname;

  Dept({required this.Deptname});
  factory Dept.fromJson(Map<String, dynamic> json) => Dept(
        Deptname: json["departement_name"],
      );
  Map<String, dynamic> toJson() => {
        "departement_name": Deptname,
      };
}

class listvisitlog extends StatefulWidget {
  // int dID;

  // listvisitlog({required this.dID});

  @override
  _listvisitlogState createState() => _listvisitlogState();
}

class _listvisitlogState extends State<listvisitlog> {
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

    final responseData = await http
        .get("https://alita.massindo.com/api/v1/visit_logs?user_id=$id");
    print("https://alita.massindo.com/api/v1/visit_logs?user_id=$id");
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visit Log bulan ini yang di input oleh',
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
                                            "Work Place : ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Departement:",
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
                                            "Address : ",
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
                                            nDataList.placename.placename,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            nDataList.deptname.Deptname,
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
                                            nDataList.placename.placeaddrsl,
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
