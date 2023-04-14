import 'dart:convert';

import 'package:alitamsniosmobile/screens/menusales.dart';
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
  // Orderitem order;

  Results({
    required this.sddoco,
    required this.sddcto,
    required this.sdan8,
    required this.sdkcoo,
    // required this.order,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    // var listArticles = json["order_items"] as List;

    // // mapping listArticles kedalam bentuk MappedIterable<dynamic, Article>
    // var iterableArticles = listArticles.map((article) {
    //   return Orderitem.fromJson(article);
    // });

    // // lalu, kita konversi dari MappedIterable kedalam bentuk List<Article>
    // var orders = List<Orderitem>.from(iterableArticles);
    return Results(
      sddoco: json["sddoco"],
      sddcto: json["sddcto"],
      sdan8: Sdan8.fromJson(json["sdan8"]),
      sdkcoo: json["sdkcoo"],
      // order: Orderitem.fromJson(json["order_items"]),
    );
  }
}

class Sdan8 {
  String abalph;
  String abdc;
  String aladd1;
  String alcoun;

  Sdan8(
      {required this.abalph,
      required this.abdc,
      required this.aladd1,
      required this.alcoun});
  factory Sdan8.fromJson(Map<String, dynamic> json) => Sdan8(
      abalph: json["abalph"],
      abdc: json["abdc"],
      aladd1: json["aladd1"],
      alcoun: json["alcoun"]);
  Map<String, dynamic> toJson() => {
        "abalph": abalph,
        "abdc": abdc,
        "aladd1": aladd1,
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

class delivery {
  String deliverynumber;
  String creator;
  String stats;
  String loc;
  String phone;
  String note;

  delivery(
      {required this.deliverynumber,
      required this.creator,
      required this.stats,
      required this.loc,
      required this.phone,
      required this.note});

  factory delivery.fromJson(Map<String, dynamic> json) {
    return delivery(
        deliverynumber: json["delivery_number"],
        creator: json["creator"],
        stats: json["status"],
        note: json["created_at"],
        phone: json["phone"],
        loc: json["location"]);
  }
}

class Security {
  String deliverynumber;
  String creator;
  String phone;
  String policinumber;
  String firstname;
  String midlename;
  String name;

  Security(
      {required this.deliverynumber,
      required this.creator,
      required this.policinumber,
      required this.firstname,
      required this.phone,
      required this.midlename,
      required this.name});

  factory Security.fromJson(Map<String, dynamic> json) {
    return Security(
        deliverynumber: json["delivery_number"],
        creator: json["creator"],
        policinumber: json["polici_number"],
        midlename: json["middle_name"],
        phone: json["phone"],
        firstname: json["first_name"],
        name: json["name"]);
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

class salessearchcomplite extends StatefulWidget {
  const salessearchcomplite({Key? key}) : super(key: key);

  @override
  _salessearchcompliteState createState() => _salessearchcompliteState();
}

class _salessearchcompliteState extends State<salessearchcomplite> {
  Color primaryColor = Color(0xff486493);
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAhead = TextEditingController();
  TextEditingController formnomor = TextEditingController();
  TextEditingController formPO = TextEditingController();
  TextEditingController formnSO = TextEditingController();
  String nomor = "";
  String po = "";
  String so = "";
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
  List<Orderitem> order = [];
  List<Security> listsec = [];
  List<delivery> deliv = [];
  String brandss = '';
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
          .get("https://alita.massindo.com/api/v1/item_master_srp5?srp5=A02");
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

  void fetchResultss() async {
    setState(() {
      loading = true;
    });

    // print(
    //     'https://alita.massindo.com/api/v1/availability_by_location?branch=1101&item_number=$number');

    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/sales_order_status?delivery_number=7525494&area_code=01103");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["results"] as List;
      print("hasil = " + rest.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          res.add(Results.fromJson(i));
        }
        loading = false;
      });
      fetchOreder();
    }
  }

  void fetchSecurity() async {
    setState(() {
      loading = true;
    });

    // print(
    //     'https://alita.massindo.com/api/v1/availability_by_location?branch=1101&item_number=$number');

    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/securityCheckDetailByDeliveryNumber?delivery_number=7525494");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      // print("hasil = " + jsonItems.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          listsec.add(Security.fromJson(i));
        }
        loading = false;
      });
      fetchOreder();
    }
  }

  void fetchdeliv() async {
    setState(() {
      loading = true;
    });

    // print(
    //     'https://alita.massindo.com/api/v1/availability_by_location?branch=1101&item_number=$number');

    final jsonResponse = await http.get(
        "https://alita.massindo.com//api/v1/showbydeliverynumber?delivery_number=7525494");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      // print("hasil = " + jsonItems.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          deliv.add(delivery.fromJson(i));
        }
        loading = false;
      });
      fetchOreder();
    }
  }

  void fetchOreder() async {
    setState(() {
      loading = true;
    });

    // print(
    //     'https://alita.massindo.com/api/v1/availability_by_location?branch=1101&item_number=$number');

    final jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/sales_order_status?delivery_number=7525494&area_code=01103");

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["results"][0]["order_items"];
      // print("hasil = " + rest.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          order.add(Orderitem.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getSWData();
    // getBrand();
    fetchResultss();
    fetchSecurity();
    fetchdeliv();
    // fetchOreder();
    // getData(code);
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
                padding: EdgeInsets.fromLTRB(0, 10, 0, 80),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => menusales()));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Siapa Customer kamu'),
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
        body: Container(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                height: 200,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Nomor Sales Order : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 35,
                      child: TextFormField(
                        onSaved: (e) => nomor = e!,
                        controller: formnomor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Nomor Sales Order",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Type Sales Order : ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          groupValue: brandss,
                          title: Text('Toko', style: TextStyle(fontSize: 14)),
                          value: 'SO',
                          onChanged: (val) {
                            setState(() {
                              brandss = val.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          groupValue: brandss,
                          title: Text(
                            'Perorangan',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'S1',
                          onChanged: (val) {
                            setState(() {
                              brandss = val.toString();
                              // getSWData(brandss);
                            });
                          },
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Expanded(
                        child: RadioListTile(
                          groupValue: brandss,
                          title: Text('Tv Shopping',
                              style: TextStyle(fontSize: 14)),
                          value: 'TS',
                          onChanged: (val) {
                            setState(() {
                              brandss = val.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          groupValue: brandss,
                          title: Text(
                            'Massindo Fair',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'TF',
                          onChanged: (val) {
                            setState(() {
                              brandss = val.toString();
                              // getSWData(brandss);
                            });
                          },
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 5,
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
                      "Customer PO : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 35,
                      child: TextFormField(
                        onSaved: (e) => po = e!,
                        controller: formPO,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Customer Po",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Surat Jalan : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 35,
                      child: TextFormField(
                        onSaved: (e) => so = e!,
                        controller: formnSO,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Surat Jalan",
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                onPressed: () {},
                splashColor: Colors.cyan.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: primaryColor),
                ),
                color: primaryColor,
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
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Detail Sales order",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 21,
                                                color: Colors.black)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              nDataList.sddoco +
                                                  "   --   " +
                                                  nDataList.sddcto +
                                                  "    --     " +
                                                  nDataList.sdkcoo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                height: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      child: Text("Delivery Number"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Description"),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Qty"),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Satuan"),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 60,
                      child: Text("Last Status"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: order.length,
                        itemBuilder: (context, i) {
                          final nDataList = order[i];
                          int h = 100;
                          int qty = nDataList.sduorg;
                          int hasil = qty ~/ h;
                          String stts = nDataList.sdlttr;
                          String prs = " Sedang diproses";
                          String btal = "Dibatalkan";
                          String slsai = "Selesai";
                          String muat = "Sedang di muat";
                          String truk = "Sedang di Truk";
                          String pck = "Sedang di Packing";
                          // ignore: unrelated_type_equality_checks
                          if (stts == "620") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(slsai,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "520") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(prs,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "980") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(btal,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "900") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(prs,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "902") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(prs,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "540") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(pck,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "560") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(muat,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "580") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(truk,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (stts == "590") {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nDataList.sddeln,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            nDataList.sddsc1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(hasil.toString(),
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(nDataList.sduom,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(slsai,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Expanded(
                flex: 1,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: res.length,
                        itemBuilder: (context, i) {
                          final nDataList = res[i];

                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Customer ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 21,
                                                color: Colors.black)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Kepada : " +
                                                  nDataList.sdan8.abalph,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Kirim : " + nDataList.sdan8.abdc,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Alamat : " +
                                                  nDataList.sdan8.aladd1 +
                                                  " , " +
                                                  nDataList.sdan8.alcoun,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
              Expanded(
                flex: 1,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: listsec.length,
                        itemBuilder: (context, i) {
                          final nDataList = listsec[i];

                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Delivery ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                                fontSize: 21,
                                                color: Colors.black)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Security : " + nDataList.creator,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Nomor Polisi : " +
                                                  nDataList.policinumber,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Expedisi : " + nDataList.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
              Expanded(
                flex: 2,
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: deliv.length,
                        itemBuilder: (context, i) {
                          final nDataList = deliv[i];

                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              nDataList.stats,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              nDataList.loc,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              nDataList.note,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ])));
  }
}
