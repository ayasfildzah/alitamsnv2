import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
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
  int lipqoh;
  int lihcom;
  int qav;
  String imdsc2;

  Results(
      {required this.liitm,
      required this.imdsc1,
      required this.imlitm,
      required this.imuom1,
      required this.limcu,
      required this.imdsc2,
      required this.lihcom,
      required this.lilocn,
      required this.lipqoh,
      required this.qav});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        liitm: json["liitm"],
        imdsc1: json["imdsc1"],
        imlitm: json["imlitm"],
        imuom1: json["imuom1"],
        lihcom: json["lihcom"],
        lilocn: json["lilocn"],
        limcu: json["limcu"],
        lipqoh: json["lipqoh"],
        qav: json["qav"],
        imdsc2: json["imdsc2"]);
  }
}

class brand {
  int id;
  String mcdc;
  String mcmcu;

  brand({required this.id, required this.mcdc, required this.mcmcu});

  factory brand.fromJson(Map<String, dynamic> json) {
    return brand(
      id: json["id"] as int,
      mcdc: json["MCDC"] as String,
      mcmcu: json["MCMCU"] as String,
    );
  }
}

class Searchallavailibility extends StatefulWidget {
  const Searchallavailibility({Key? key}) : super(key: key);

  @override
  _SearchallavailibilityState createState() => _SearchallavailibilityState();
}

class _SearchallavailibilityState extends State<Searchallavailibility> {
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAhead = TextEditingController();
  final TextEditingController formloc = TextEditingController();
  final TextEditingController formitem = TextEditingController();
  String _selected = '';
  String selectbrand = '';
  List<User> users = <User>[];
  List<brand> brands = <brand>[];
  bool _visible = false;
  bool loading = false;
  String title = '';
  String code = '';
  String item = "";
  String item2 = "";
  String loc = "";
  String number = "";
  List<Results> res = [];
  List<Results> list = [];
  List<dynamic> newData = [];

  void getSWData() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/item_masters");
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

  void getBrand() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/branches");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['result'] as List;
        //  print(array);
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

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code");
    print(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code");
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"]["results"] as List;
      // print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          list.add(Results.fromJson(i));
        }
        loading = false;
      });
    }
  }

  Future<void> getData2() async {
    setState(() {
      loading = true;
    });
    item = formitem.value.text;
    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code&item_number=$item");
    print(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code&item_number=$item");
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"]["results"] as List;
      // print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          res.add(Results.fromJson(i));
        }
        loading = false;
      });
    }
  }

  Future<void> getData3() async {
    setState(() {
      loading = true;
    });

    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code&item_number=$item2");
    print(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code&item_number=$item2");
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"]["results"] as List;
      // print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          res.add(Results.fromJson(i));
        }
        loading = false;
      });
    }
  }
// Future<Future> showdetail() async {

//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Favorite Color'),
//             content: Container(
//               width: double.minPositive,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: colorList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     title: Text(colorList[index]),
//                     onTap: () {
//                       Navigator.pop(context, colorList[index]);
//                     },
//                   );
//                 },
//               ),
//             ),
//           );
//         });
//   }

  @override
  void initState() {
    super.initState();
    getSWData();
    getBrand();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Availibility',
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
                    Text(
                      "Location : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => loc = e!,
                      controller: formloc,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Location",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Item Number : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => number = e!,
                      controller: formitem,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Item Number",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Area: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TypeAheadFormField<brand>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAhead,
                          decoration: InputDecoration(hintText: 'Area')),
                      suggestionsCallback: (s) => brands.where((c) =>
                          c.mcdc.toLowerCase().contains(s.toLowerCase())),
                      itemBuilder: (ctx, brands) => Text(brands.mcdc,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          )),
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (brands) {
                        _typeAhead.text = brands.mcdc;
                        code = brands.mcmcu.toString();

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
                      height: 20,
                    ),
                    const Text(
                      "Item Description: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TypeAheadFormField<User>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          decoration:
                              InputDecoration(hintText: 'Item Description')),
                      suggestionsCallback: (s) => users.where((c) =>
                          c.name.toLowerCase().contains(s.toLowerCase())),
                      itemBuilder: (ctx, users) => Text(users.name,
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'OpenSans')),
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (users) {
                        _typeAheadController.text = users.name;
                        item2 = users.email.toString();
                        getData3();
                        print(item2);
                        res.clear();
                        list.clear();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select ';
                        }
                      },
                      onSaved: (value) => _selected = value!,
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
                if (code != Null) {
                  getData();
                  res.clear();
                  list.clear();
                }

                // ignore: unrelated_type_equality_checks
                if (formitem != Null) {
                  getData2();
                }
                res.clear();
                list.clear();
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
                        int qoh = nDataList.lipqoh;
                        int lih = nDataList.lihcom;
                        int qav = nDataList.qav;
                        int hq = qoh ~/ 100;
                        int hl = lih ~/ 100;
                        int hv = qav ~/ 100;

                        return Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width / 1,
                                  height: 200,
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        nDataList.imdsc1,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(nDataList.imlitm),
                                      Text("Branch : " + nDataList.limcu),
                                      Text("Loc : " +
                                          nDataList.lilocn +
                                          "   ---   " +
                                          "Uom : " +
                                          nDataList.imuom1),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("QOH : "),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text("Ordered : "),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text("QAV : "),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.lightBlue.shade100,
                                                shape: BoxShape.circle),
                                            child: Text(hq.toString()),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.lightBlue.shade100,
                                                shape: BoxShape.circle),
                                            child: Text(hl.toString()),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.lightBlue.shade100,
                                                shape: BoxShape.circle),
                                            child: Text(hv.toString()),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ));

                        // By default show a loading spinner.
                      },
                    ),
            ),
          ]),
        ));
  }
}
