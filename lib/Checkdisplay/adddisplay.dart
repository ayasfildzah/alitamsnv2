import 'dart:convert';
import 'package:alitamsniosmobile/Checkdisplay/addcheckdisplay.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? office;

class User {
  int id;
  int userid;
  String name;

  User({required this.id, required this.userid, required this.name});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["work_place_id"],
      userid: parsedJson["id"],
      name: parsedJson["office_name"],
    );
  }
}

class display {
  int id;
  int userid;
  int workplaceid;

  display({required this.id, required this.userid, required this.workplaceid});

  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
      id: parsedJson['id'],
      userid: parsedJson["user_id"],
      workplaceid: parsedJson["work_place_id"],
    );
  }
}

class adddisplay extends StatefulWidget {
  const adddisplay({Key? key}) : super(key: key);

  @override
  _adddisplayState createState() => _adddisplayState();
}

class _adddisplayState extends State<adddisplay> {
  // late Data data;
  Future<List<User>>? futureuser;
  String off = "";
  int? id;
  String idshow = '';
  List<display>? dis;

  Future<List<User>> getSWData(idshow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id')!;
    print('https://alita.massindo.com/api/v1/attendances?user_id=$id');
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/attendances?user_id=$id');

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      // var rest = jsonItems["result"] as List;
      List<User> products = jsonItems.map<User>((json) {
        return User.fromJson(json);
      }).toList();
      print("object = " + idshow);
      // print(jsonItems);
      return products;
    } else {
      throw Exception('Failed to load dataabsen from internet');
    }
  }

  Future<display?> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getInt('id')!;

    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/check_displays"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': id.toString(),
          'work_place_id': idshow,
        }));

    if (response.statusCode == 200) {
      print("Berhasil input");
      var result = jsonDecode(response.body);
      print(result);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => checkdisplay(jsondata: result)),
      );
      return display.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    futureuser = getSWData(idshow);
    // read();
  }

  @override
  Widget build(BuildContext context) {
    // read();
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.all(20),
            // width: MediaQuery.of(context).size.width / 1,
            // height: MediaQuery.of(context).size.height / 1.8,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100),

                // Container(
                //     width: MediaQuery.of(context).size.width / 1.2,
                //     height: MediaQuery.of(context).size.height / 2.3,
                //     decoration: BoxDecoration(
                //       color: Colors.lightBlue.shade50,
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.white,
                //           blurRadius: 8.0,
                //           offset: Offset(0.0, 5.0),
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       children: [

                //         Text(
                //           "di PT Massindo Karya Prima Bekasi",
                //           style: TextStyle(
                //               fontSize: 16,
                //               color: Colors.blue,
                //               fontFamily: 'OpensSans',
                //               fontWeight: FontWeight.bold),
                //           textAlign: TextAlign.center,
                //         ),
                //         SizedBox(height: 20),
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             FlatButton(
                //               onPressed: () {
                //                 create();
                //                 // setState(() {
                //                 //   Navigator.push(
                //                 //       context,
                //                 //       new MaterialPageRoute(
                //                 //           builder: (context) => checkdisplay()));
                //                 // });
                //               },
                //               child: Text(
                //                 "Klik untuk melakukan kegiatan selanjutnya ",
                //                 style: TextStyle(
                //                   fontSize: 12,
                //                   color: Colors.red,
                //                 ),
                //                 textAlign: TextAlign.right,
                //               ),
                //             ),
                //             Icon(
                //               Icons.skip_next,
                //             )
                //           ],
                //         )
                //       ],
                //     )),
                Expanded(
                  child: FutureBuilder<List<User>>(
                    future: futureuser,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<User>? data = snapshot.data;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              idshow = data!.first.id.toString();
                              String id = data.first.userid.toString();
                              String nama = data.first.name;
                              getSWData(idshow);
                              print("idd = " + id);
                              print("objectid = " + idshow);
                              return Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade50,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 8.0,
                                        offset: Offset(0.0, 5.0),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Periksa Kembali !!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpensSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(
                                          Icons.verified,
                                          size: 80,
                                          color: Colors.teal.shade300,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Jika Lokasi Anda Sudah Sesuai",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'OpensSans',
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "di " + " " + nama,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                              fontFamily: 'OpensSans',
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                create();
                                                // setState(() {
                                                //   Navigator.push(
                                                //       context,
                                                //       new MaterialPageRoute(
                                                //           builder: (context) =>
                                                //               checkdisplay()));
                                                // });
                                              },
                                              child: Text(
                                                "Klik untuk melakukan kegiatan selanjutnya ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            Icon(
                                              Icons.skip_next,
                                            )
                                          ],
                                        )
                                      ]));
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return CircularProgressIndicator.adaptive();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
