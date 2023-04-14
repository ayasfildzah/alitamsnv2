import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

String? number;

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

class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["code"] as String,
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

class Searchbyarea extends StatefulWidget {
  const Searchbyarea({Key? key}) : super(key: key);

  @override
  _SearchbyareaState createState() => _SearchbyareaState();
}

class _SearchbyareaState extends State<Searchbyarea> {
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
  String hasil = '';
  String code2 = '';
  List<item> listModel = [];
  List<Results> res = [];

  void getSWData() async {
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

  void getData(code) async {
    setState(() {
      loading = false;
    });
    try {
      final response = await http
          .get("https://alita.massindo.com/api/v1/item_master_srp5?srp5=$code");
      print("https://alita.massindo.com/api/v1/item_master_srp5?srp5=$code");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['results'] as List;
        //  print(array);
        listModel =
            array.map<item>((parsedJson) => item.fromJson(parsedJson)).toList();
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
  void fetchResultss() async {
    hasil = number!;
    print(hasil);
    setState(() {
      loading = true;
    });

    print(
        'https://alita.massindo.com/api/v1/availability_by_location?branch=$code2&item_number=$hasil');
    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/availability_by_location?branch=$code2&item_number=$hasil");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"]["results"] as List;
      print("hasil = " + jsonItems.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          res.add(Results.fromJson(i));
        }
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Availability',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: Colors.blueAccent,
              ),
              content: setupAlertDialoadContainer(),
            );
          });
    }
  }

  Widget setupAlertDialoadContainer() {
    // fetchResultss(code);
    return Container(
      height: 250.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: res.length,
              itemBuilder: (BuildContext context, int index) {
                final nDataList = res[index];
                int qoh = nDataList.lipqoh;
                int lih = nDataList.lihcom;
                int qav = nDataList.qav;
                int hq = qoh ~/ 100;
                int hl = lih ~/ 100;
                int hv = qav ~/ 100;
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        nDataList.imdsc1,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(nDataList.imlitm),
                      // Text("Branch : " + nDataList.limcu),
                      Text("Loc : " +
                          nDataList.lilocn +
                          "   ---   " +
                          "Uom : " +
                          nDataList.imuom1),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade100,
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
                                color: Colors.lightBlue.shade100,
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
                                color: Colors.lightBlue.shade100,
                                shape: BoxShape.circle),
                            child: Text(hv.toString()),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSWData();
    getBrand();
    // fetchResultss();
    getData(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Availibility by Area - Type',
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
                      "Type Product : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TypeAheadFormField<User>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          decoration:
                              InputDecoration(hintText: 'Type Product')),
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
                        code = users.email.toString();

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
                        code2 = brands.mcmcu.toString();

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
                      itemCount: listModel.length,
                      itemBuilder: (context, i) {
                        final nDataList = listModel[i];

                        return InkWell(
                          onTap: () {
                            number = listModel[i].imlitm;
                            // print("no" + number.toString());
                            fetchResultss();
                          },
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
                                              nDataList.imdsc1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                                nDataList.imsrp5.decription
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                            Text(
                                                nDataList.imsrp3.decription
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
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
