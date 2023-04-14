import 'dart:convert';

import 'package:alitamsniosmobile/print/pdfhigh.dart';
import 'package:alitamsniosmobile/print/pdfresult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["IMDSC1"] as String,
      email: json["IMLITM"] as String,
    );
  }
}

class Results {
  String liitm;
  String imdsc1;
  String imlitm;
  String imuom1;
  String limcu;
  String lilocn;
  String imglpt;
  int lipqoh;
  int lihcom;
  int qav;
  String imdsc2;
  // String shortitem;
  // Images img;

  Results({
    required this.liitm,
    required this.imdsc1,
    required this.imlitm,
    required this.imuom1,
    required this.limcu,
    required this.imdsc2,
    required this.lihcom,
    required this.lilocn,
    required this.imglpt,
    required this.lipqoh,
    required this.qav,
    // required this.shortitem,
    // required this.img
  });
  factory Results.fromJson(Map<String, dynamic> json) => Results(
        liitm: json["liitm"],
        imdsc1: json["imdsc1"],
        imlitm: json["imlitm"],
        imuom1: json["imuom1"],
        lihcom: json["lihcom"],
        lilocn: json["lilocn"],
        imglpt: json["imglpt"],
        limcu: json["limcu"],
        lipqoh: json["lipqoh"],
        qav: json["qav"],
        imdsc2: json["imdsc2"],
        // shortitem: json["short_item"] as String,
        // // img: Images.fromJson(json["image"]),
      );
  Map<String, dynamic> toJson() => {
        "liitm": liitm,
        "imdsc1": imdsc1,
        "imlitm": imlitm,
        "imuom1": imuom1,
        "lihcom": lihcom,
        "lilocn": lilocn,
        "imglpt": imglpt,
        "limcu": limcu,
        "lipqoh": lipqoh,
        "qav": qav,
        "imdsc2": imdsc2,
        // "short_item": shortitem,
        // "image": img.toJson(),
      };
}

class highmodel {
  int id;
  String short;
  String item;
  String desc;
  images img;

  highmodel({
    required this.id,
    required this.short,
    required this.item,
    required this.desc,
    required this.img,
  });
  factory highmodel.fromJson(Map<String, dynamic> json) => highmodel(
        id: json["id"],
        short: json["short_item"],
        item: json["item_master"],
        desc: json["desc1"],
        img: images.fromJson(json["image"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "short_item": short,
        "item_master": item,
        "desc1": desc,
        "image": img.toJson(),
      };
}

class images {
  String url;

  images({required this.url});
  factory images.fromJson(Map<String, dynamic> json) => images(
        url: json["url"],
      );
  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class brand {
  int id;
  String mcdc;
  String mcmcu;
  String mcstyl;

  brand(
      {required this.id,
      required this.mcdc,
      required this.mcmcu,
      required this.mcstyl});

  factory brand.fromJson(Map<String, dynamic> json) {
    return brand(
      id: json["id"] as int,
      mcdc: json["MCDC"] as String,
      mcmcu: json["MCMCU"] as String,
      mcstyl: json["MCSTYL"],
    );
  }
}

class highavailibility extends StatefulWidget {
  const highavailibility({Key? key}) : super(key: key);

  @override
  _highavailibilityState createState() => _highavailibilityState();
}

class _highavailibilityState extends State<highavailibility> {
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAhead = TextEditingController();
  String _selected = '';
  String selectbrand = '';
  List<User> users = <User>[];
  List<brand> brands = <brand>[];
  bool _visible = false;
  bool loading = false;
  String title = '';
  String code = '';
  List<Results> listModel = [];
  List<highmodel> listModell = [];
  String radiobrand = "";
  Color primaryColor = Color(0xff486493);

  void getSWData() async {
    int index;
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/product_type_srp5");

      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['result'] as List;
        //  print(array);
        users =
            array.map<User>((parsedJson) => User.fromJson(parsedJson)).toList();

        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  Future<List<brand>?> getBrand() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/branches");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data["result"] as List;
        var filteredList;
        filteredList = rest.where((val) => val["MCSTYL"] == "BS");
        print(filteredList);
        brands = rest
            .map<brand>((parsedJson) => brand.fromJson(parsedJson))
            .toList();
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting user.");
      }
    } catch (e) {
      print("Error getting user.");
    }
  }

  Future<Null> fetchResultss() async {
    setState(() {
      loading = true;
    });

    http.Response jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/availability_by_location?branch=$code&brand_code=$radiobrand');
    print(
        'https://alita.massindo.com/api/v1/availability_by_location?branch=$code&brand_code=$radiobrand');
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"]["results"] as List;
      // print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          listModel.add(Results.fromJson(i));
        }
        loading = false;
      });
    }
  }

  Future<Null> showfoto(String item) async {
    setState(() {
      loading = true;
    });
    http.Response jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/image_item_masters?short_item=' +
            item);
    print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
        item);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;

      setState(() {
        for (Map<String, dynamic> i in rest) {
          listModell.add(highmodel.fromJson(i));
        }
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Image Availability',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                color: Colors.blueAccent,
              ),
              content: setupAlertDialoadContainer(),
            );
          });
    } else {
      print("data tidak ada");
    }
  }

  @override
  void initState() {
    super.initState();
    getSWData();
    getBrand();
    // showfoto();
    // fetchResultss();
    // getData();
    // fetchData();
    // getData(code);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final pdfFile =
                                            await PdfHighApi.generate(
                                                branches: code,
                                                brand: radiobrand,
                                                nmaloc : _typeAhead.text 
                                               );
                                        FileHandleApi.openFile(pdfFile);
                                      
            },
            icon: Icon(Icons.save, size: 20),
            label: Text("Save", style: TextStyle(fontSize: 14)),
            backgroundColor: primaryColor,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              width: MediaQuery.of(context).size.width / 1,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('High Availibility'),
                ],
              ),
            ),
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 130,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bginput.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                // height: 220,
                child: SingleChildScrollView(
                  child: Form(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Area: ",
                              style: TextStyle(fontSize: 16),
                            ),
                            TypeAheadFormField<brand>(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: _typeAhead,
                                  decoration:
                                      InputDecoration(hintText: 'Area')),
                              suggestionsCallback: (s) =>
                                  brands.where((c) => c.mcstyl == "BS"),
                              itemBuilder: (ctx, brands) => Text(brands.mcdc,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold)),
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (brands) {
                                _typeAhead.text = brands.mcdc;
                                code = brands.mcmcu.toString();
                                // fetchResultss();
                                listModel.clear();
                                print(code);
                              },
                              validator: (values) {
                                if (values!.isEmpty) {
                                  return 'Please select ';
                                }
                              },
                              onSaved: (values) => selectbrand = values!,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Brands : ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(children: [
                              Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Comforta',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFC";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Comforta X',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFX";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Spring Air',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFS";

                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Superfit',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFF";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Theraphedic',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFT";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Kasur Busa',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFB";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Sofa',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFE";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Kursi Plastik',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFO";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      // shape: BoxShape.circle,
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            offset: Offset(
                                                                0.2, 0.5),
                                                            blurRadius: 10.0)
                                                      ]),
                                                  child: Text(
                                                    'Barang Agen',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                listModel.clear();
                                                radiobrand = "INFG";
                                                fetchResultss();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        // Container(
                                        //   child: Column(children: <Widget>[
                                        //     RadioListTile(
                                        //       groupValue: radiobrand,
                                        //       title: Text(
                                        //         'Super Fit',
                                        //         style: TextStyle(fontSize: 14),
                                        //       ),
                                        //       value: 'INFF',
                                        //       onChanged: (val) {
                                        //         setState(() {
                                        //           radiobrand = val.toString();
                                        //           // fetchResultss();
                                        //           listModel.clear();
                                        //         });
                                        //       },
                                        //     ),
                                        //     Container(
                                        //       child: RadioListTile(
                                        //         groupValue: radiobrand,
                                        //         title: Text(
                                        //           'Comforta X',
                                        //           style: TextStyle(fontSize: 14),
                                        //         ),
                                        //         value: 'INFX',
                                        //         onChanged: (val) {
                                        //           setState(() {
                                        //             radiobrand = val.toString();
                                        //             // fetchResultss();
                                        //             listModel.clear();
                                        //           });
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       child: RadioListTile(
                                        //         groupValue: radiobrand,
                                        //         title: Text(
                                        //           'Spring Air',
                                        //           style: TextStyle(fontSize: 14),
                                        //         ),
                                        //         value: 'INFS',
                                        //         onChanged: (val) {
                                        //           setState(() {
                                        //             radiobrand = val.toString();
                                        //             // fetchResultss();
                                        //             listModel.clear();
                                        //           });
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       child: RadioListTile(
                                        //         groupValue: radiobrand,
                                        //         title: Text(
                                        //           'Comforta',
                                        //           style: TextStyle(fontSize: 14),
                                        //         ),
                                        //         value: 'INFC',
                                        //         onChanged: (val) {
                                        //           setState(() {
                                        //             radiobrand = val.toString();
                                        //             // fetchResultss();
                                        //             listModel.clear();
                                        //           });
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       child: RadioListTile(
                                        //         groupValue: radiobrand,
                                        //         title: Text(
                                        //           'Theraphedic',
                                        //           style: TextStyle(fontSize: 14),
                                        //         ),
                                        //         value: 'INFT',
                                        //         onChanged: (val) {
                                        //           setState(() {
                                        //             radiobrand = val.toString();
                                        //             // fetchResultss();
                                        //             listModel.clear();
                                        //           });
                                        //         },
                                        //       ),
                                        //     ),
                                        //   ]),
                                        // ),
                                      )))
                            ])
                          ]),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // RaisedButton(
              //   child: Text(
              //     'Search',
              //     style: TextStyle(fontSize: 13, color: Colors.white),
              //   ),
              //   onPressed: () {
              //     fetchResultss();

              //     setState(() {
              //       _visible = !_visible;
              //     });
              //   },
              //   splashColor: primaryColor,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(18.0),
              //     side: BorderSide(color: Colors.blueGrey),
              //   ),
              //   color: primaryColor,
              //   animationDuration: Duration(seconds: 2),
              // ),
              // Visibility(
              //   visible: _visible,
              //   child: Text(
              //     'High Availibility > 5 ',
              //     style: TextStyle(fontSize: 14),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 4,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: listModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          final nDataList = listModel[index];
                          int qoh = nDataList.lipqoh;
                          int lih = nDataList.lihcom;
                          int qav = nDataList.qav;
                          String im = nDataList.imglpt;
                          String item = nDataList.liitm;
                          // String short = nDataList.shortitem;
                          String img = nDataList.imuom1;
                          int hq = qoh ~/ 100;
                          int hl = lih ~/ 100;
                          int hv = qav ~/ 100;
                          // showfoto(item);
                          print(item);
                          if (hv >= 2 && im == "INFC") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 45,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFX") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 40.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(width: 0),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 45,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 2 && im == "INFF") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFS") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFT") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 2 && im == "INFB") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Icon(
                                                  //   Icons.bedroom_child,
                                                  //   color: Colors
                                                  //       .lightBlue.shade200,
                                                  //   size: 65,
                                                  // ),
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFE") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFG") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          }
                          if (hv >= 0 && im == "INFO") {
                            return InkWell(
                                onTap: () {
                                  showfoto(item);
                                  listModell.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => checkdisplaydetails(
                                  //               dID: nDataList.id,
                                  //             )));
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  // Text(
                                                  //   "Show Image",
                                                  //   style:
                                                  //       TextStyle(fontSize: 10),
                                                  // )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      nDataList.imdsc1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(nDataList.imlitm),
                                                  // Text("Branch : " + nDataList.limcu),
                                                  // Text("Loc : " +
                                                  //     nDataList.lilocn +
                                                  //     "   ---   " +
                                                  //     "Uom : " +
                                                  //     nDataList.imuom1),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Text("QOH : "),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Text("Ordered : "),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("QAV : "),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hq.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hl.toString()),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child:
                                                            Text(hv.toString()),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]))
                                  ],
                                ));
                          } else {
                            return Container();
                          }
                          // By default show a loading spinner.
                        },
                      ),
              ),
            ]),
          ),
        ));
  }

  Widget setupAlertDialoadContainer() {
    // fetchResultss(code);
    return Container(
      height: 100.0, // Change as per your requirement
      width: MediaQuery.of(context).size.width /
          1, // Change as per your requirement
      child: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: listModell.length,
              itemBuilder: (BuildContext context, int index) {
                final nDataList = listModell[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 1,
                        height: 80,
                        child: Row(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                // ignore: unnecessary_null_comparison
                                child: nDataList.img.url == null
                                    ? const Icon(
                                        Icons.bedroom_child,
                                        color: Colors.lightBlue,
                                        size: 65,
                                      )
                                    : Image.network(
                                        nDataList.img.url,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              //  width: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nDataList.short.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    nDataList.desc.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // width: 70,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
