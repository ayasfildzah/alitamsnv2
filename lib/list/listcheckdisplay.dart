import 'dart:convert';

import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/list/listcheckdetails.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? finalname;

class display {
  int id;
  String name;
  String date;
  int total;

  display(
      {required this.id,
      required this.name,
      required this.total,
      required this.date});
  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      date: parsedJson["created_at"],
      total: parsedJson["total"],
    );
  }
}

class listcheckdisplay extends StatefulWidget {
  const listcheckdisplay({Key? key}) : super(key: key);

  @override
  _listcheckdisplayState createState() => _listcheckdisplayState();
}

class _listcheckdisplayState extends State<listcheckdisplay> {
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
        .get("https://alita.massindo.com/api/v1/check_displays?user_id=$id");
    print("https://alita.massindo.com/api/v1/check_displays?user_id=$id");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
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
              Container(
                  // color: Colors.lightBlue.shade100,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Lokasi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 140,
                      ),
                      Container(
                          width: 100,
                          child: Text(
                            "Total Check Display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                                color: Colors.blue),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  )),
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => checkdisplaydetails(
                                            dID: nDataList.id,
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 250,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nDataList.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Created at : " +
                                                dateStr +
                                                " Jam " +
                                                showjam,
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      nDataList.total.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
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
