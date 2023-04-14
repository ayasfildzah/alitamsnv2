import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

String? number;

class Results {
  String sddoco;
  String sddcto;
  Sdan8 sdan8;
  String sdkcoo;
  Orderitem order;

  Results({
    required this.sddoco,
    required this.sddcto,
    required this.sdan8,
    required this.sdkcoo,
    required this.order,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      sddoco: json["sddoco"],
      sddcto: json["sddcto"],
      sdan8: Sdan8.fromJson(json["sdan8"]),
      sdkcoo: json["sdkcoo"],
      order: Orderitem.fromJson(json["order_items"]),
    );
  }
}

class Sdan8 {
  String aban8;
  String abdc;
  String aladd1;
  String abalky;
  String alcoun;

  Sdan8(
      {required this.aban8,
      required this.abdc,
      required this.aladd1,
      required this.abalky,
      required this.alcoun});
  factory Sdan8.fromJson(Map<String, dynamic> json) => Sdan8(
      aban8: json["aban8"],
      abdc: json["abdc"],
      aladd1: json["aladd1"],
      abalky: json["abalky"],
      alcoun: json["alcoun"]);
  Map<String, dynamic> toJson() => {
        "aban8": aban8,
        "abdc": abdc,
        "aladd1": aladd1,
        "abalky": abalky,
        "alcoun": alcoun,
      };
}

class Orderitem {
  String sddeln;
  String sddsc1;
  String sduom;
  int sduorg;
  String sdlttr;

  Orderitem(
      {required this.sddeln,
      required this.sddsc1,
      required this.sduom,
      required this.sdlttr,
      required this.sduorg});

  factory Orderitem.fromJson(Map<String, dynamic> json) {
    return Orderitem(
        sddeln: json["sddeln"],
        sddsc1: json["sddsc1"],
        sduom: json["sduom"],
        sduorg: json["sduorg"],
        sdlttr: json["sdlttr"]);
  }
}

class User {
  int id;
  String name;
  String code;

  User({required this.id, required this.name, required this.code});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      code: json["code"] as String,
    );
  }
}

class item {
  int id;
  String imdsc1;
  String imlitm;
  Imsrp5 imsrp5;
  Imsrp3 imsrp3;

  item(
      {required this.id,
      required this.imdsc1,
      required this.imlitm,
      required this.imsrp5,
      required this.imsrp3});

  factory item.fromJson(Map<String, dynamic> json) {
    return item(
        id: json["id"] as int,
        imdsc1: json["imdsc1"] as String,
        imlitm: json["imlitm"] as String,
        imsrp5: Imsrp5.fromJson(json["imsrp5"]),
        imsrp3: Imsrp3.fromJson(json["imsrp3"]));
  }
}

class Imsrp5 {
  String decription;

  Imsrp5({required this.decription});
  factory Imsrp5.fromJson(Map<String, dynamic> json) => Imsrp5(
        decription: json["description"],
      );
  Map<String, dynamic> toJson() => {
        "description": decription,
      };
}

class Imsrp3 {
  String decription;

  Imsrp3({required this.decription});
  factory Imsrp3.fromJson(Map<String, dynamic> json) => Imsrp3(
        decription: json["description"],
      );
  Map<String, dynamic> toJson() => {
        "description": decription,
      };
}

class brand {
  int id;
  String abdc;
  String aban8;
  String abalky;
  String aladd1;
  String aladd2;

  brand(
      {required this.id,
      required this.abdc,
      required this.aban8,
      required this.abalky,
      required this.aladd1,
      required this.aladd2});

  factory brand.fromJson(Map<String, dynamic> json) {
    return brand(
      id: json["id"] as int,
      abdc: json["abdc"] as String,
      aban8: json["aban8"] as String,
      abalky: json["abalky"] as String,
      aladd1: json["aladd1"] as String,
      aladd2: json["aladd2"] as String,
    );
  }
}

class Salesorderbyreguler extends StatefulWidget {
  const Salesorderbyreguler({Key? key}) : super(key: key);

  @override
  _SalesorderbyregulerState createState() => _SalesorderbyregulerState();
}

class _SalesorderbyregulerState extends State<Salesorderbyreguler> {
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
  String code2 = '';
  List<item> listModel = [];
  List<Results> res = [];

  void getSWData() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/customer_indirect");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['rows'] as List;
        // print(array);
        brands = array
            .map<brand>((parsedJson) => brand.fromJson(parsedJson))
            .toList();
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

  void getBrand() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/areas");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['result'] as List;
        // print(array);
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

  void getData(code) async {
    setState(() {
      loading = true;
    });

    print(
        "https://alita.massindo.com/api/v1/sales_order_status?area_code=$code2&address_book=$code");

    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/sales_order_status?area_code=$code2&address_book=$code");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["results"][0]["order_items"];
      print("hasil = " + rest.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          res.add(Results.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSWData();
    getBrand();
    // fetchResultss();
    // getData(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 50,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                    colors: [Colors.teal.shade300, Colors.teal.shade200],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            SizedBox(
              height: 10,
            ),
            Form(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Store : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TypeAheadFormField<brand>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          decoration: InputDecoration(
                              hintText: 'Search custom direct')),
                      suggestionsCallback: (s) => brands.where((c) =>
                          c.abdc.toLowerCase().contains(s.toLowerCase())),
                      itemBuilder: (ctx, users) => Text(users.abdc,
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'OpenSans')),
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (users) {
                        _typeAheadController.text = users.abdc;
                        code = users.aban8.toString();
                        // getData(code);
                        print(code);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select ';
                        }
                      },
                      onSaved: (value) => _selected = value!,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Area: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TypeAheadFormField<User>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAhead,
                          decoration: InputDecoration(hintText: 'Area')),
                      suggestionsCallback: (s) => users.where((c) =>
                          c.name.toLowerCase().contains(s.toLowerCase())),
                      itemBuilder: (ctx, brands) => Text(brands.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          )),
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (brands) {
                        _typeAhead.text = brands.name;
                        code2 = brands.code.toString();

                        print(code2);
                      },
                      validator: (values) {
                        if (values!.isEmpty) {
                          return 'Please select ';
                        }
                      },
                      onSaved: (values) => selectbrand = values!,
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Search',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              onPressed: () {
                getData(code);
              },
              splashColor: Colors.cyan.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
              color: Colors.teal.shade300,
              animationDuration: Duration(seconds: 2),
            ),
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: res.length,
                      itemBuilder: (context, i) {
                        final nDataList = res[i];

                        return InkWell(
                          // onTap: () {
                          //   number = listModel[i].imlitm;
                          //   print("no" + number.toString());
                          //   fetchResultss();
                          // },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(15),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              nDataList.sddoco,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                                nDataList.sdan8.abdc.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                            // Text(
                                            //     nDataList.order.sddeln
                                            //         .toString(),
                                            //     style: TextStyle(
                                            //         fontSize: 12,
                                            //         color: Colors.black)),
                                            Text("---------------------------"),
                                          ],
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
          ]),
        ));
  }
}
