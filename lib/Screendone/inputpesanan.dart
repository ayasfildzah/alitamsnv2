import 'dart:convert';

import 'package:alitamsniosmobile/Salesorder/salesorderbystore.dart';
import 'package:alitamsniosmobile/backend/constants.dart';
import 'package:alitamsniosmobile/print/cetak.dart';
import 'package:alitamsniosmobile/screens/detailproduk.dart';

import 'package:alitamsniosmobile/screens/pilihcustomer.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Results {
  int id;
  String liitm;
  String IMDSC1;
  String imlitm;
  String IMSRP2;
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
    required this.id,
    required this.liitm,
    required this.IMDSC1,
    required this.imlitm,
    required this.IMSRP2,
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
        id: json["id"],
        liitm: json["liitm"],
        IMDSC1: json["IMDSC1"],
        imlitm: json["IMLITM"],
        IMSRP2: json["IMSRP2"],
        lihcom: json["lihcom"],
        lilocn: json["lilocn"],
        imglpt: json["IMGLPT"],
        limcu: json["IMITM"],
        lipqoh: json["lipqoh"],
        qav: json["qav"],
        imdsc2: json["IMDSC2"],
        // shortitem: json["short_item"] as String,
        // // img: Images.fromJson(json["image"]),
      );
  Map<String, dynamic> toJson() => {
        "id": liitm,
        "liitm": liitm,
        "IMDSC1": IMDSC1,
        "imlitm": imlitm,
        "IMSRP2": IMSRP2,
        "lihcom": lihcom,
        "lilocn": lilocn,
        "IMGLPT": imglpt,
        "IMITM": limcu,
        "lipqoh": lipqoh,
        "qav": qav,
        "IMDSC2": imdsc2,
        // "short_item": shortitem,
        // "image": img.toJson(),
      };
}

class SPmodel {
  int id;
  String nosp;
  String cusname;

  SPmodel({
    required this.id,
    required this.nosp,
    required this.cusname,
  });
  factory SPmodel.fromJson(Map<String, dynamic> json) => SPmodel(
        id: json["id"],
        nosp: json["no_sp"],
        cusname: json["customer_name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nosp": nosp,
        "customer_name": cusname,
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

class Inputpesan extends StatefulWidget {
  // final String pemilik;
  // final String alamat;
  // final Invoice invoice;
  // const Inputpesan(
  //     {Key? key,
  //     // required this.pemilik,
  //     // required this.alamat,
  //     required this.invoice})
  //     : super(key: key);

  @override
  State<Inputpesan> createState() => _InputpesanState();
}

class _InputpesanState extends State<Inputpesan> {
  Color primaryColor = Color(0xff486493);
  bool loading = false;
  List<Results> listModell = <Results>[];
  List<Results> listModel = <Results>[];
  // List<Results> brands = <Results>[];
  List<SPmodel> model = <SPmodel>[];
  String brand = '';
  String namabrand = '';
  String no = '';
  String id = '';
  String srp = '';
  late int a;
  String nma = "";
  String desc2 = "";
  String item = "";

  Future<SPmodel?> create() async {
    print("object = " + item);
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/order_letter_details"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'qty': "1",
          'order_letter_id': id,
          'no_sp': no,
          'unit_price': "",
          'item_number': item,
          'desc_1': nma,
          "desc_2": "",
          "brand": namabrand,
          "item_type": "null",
        }));
    print("result = " + response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);

      return SPmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Results> result = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      result = listModell;
    } else {
      result = listModell
          .where((user) =>
              user.IMDSC1.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      showfoto();
      listModell = result;
    });
  }

  Future<void> showSP() async {
    http.Response jsonResponse =
        await http.get('https://alita.massindo.com/api/v1/order_letters');
    // print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
    //     item);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          model.add(SPmodel.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

  Future<List<Results>?> showjenis() async {
    // setState(() {
    //   loading = true;
    // });
    print("nama = " + brand + "code = " + srp);
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/item_masters");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data["result"] as List;
        var filteredList;
        filteredList =
            rest.where((val) => val["IMGLPT"] == brand && val["IMSRP2"] == srp);
        // && val["IMSRP2"] == "1"
        // rest.forEach((val) =>
        //     filteredList.add(rest.where((val) => val["IMGLPT"] == "INFC")));
        //print(filteredList);
        listModel = filteredList
            .map<Results>((parsedJson) => Results.fromJson(parsedJson))
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

  Future<List<Results>?> showfoto() async {
    // setState(() {
    //   loading = true;
    // });
    print("nama = " + brand);
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/item_masters");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data["result"] as List;
        var filteredList;
        filteredList = rest.where((val) => val["IMGLPT"] == brand);
        // && val["IMSRP2"] == "1"
        // rest.forEach((val) =>
        //     filteredList.add(rest.where((val) => val["IMGLPT"] == "INFC")));
        //print(filteredList);
        listModell = filteredList
            .map<Results>((parsedJson) => Results.fromJson(parsedJson))
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

  Saveproduk(String item, String nma, String desc2, String brand,
      String namabrand) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('itemnumber', item);
    prefs.setString('desc1', nma);
    prefs.setString('desc2', desc2);
    prefs.setString('brand', brand);
    prefs.setString('nmabrand', namabrand);
  }

  @override
  void initState() {
    super.initState();
    //showfoto();
    showSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pilihcustomer()));
                          },
                        ),
                        Text(
                          'Input Surat Pesanan',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Row(children: [
                      Container(
                        width: 270,
                        height: 36,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          // onSaved: (e) => nomor = e!,
                          // controller: formnomor,
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "search",
                            prefixIcon:
                                Icon(Icons.search, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.shopping_cart,
                          color: Colors.black45, size: 30),
                    ]),
                  ],
                ),
              ),
            ],
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
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Filter Brand :',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'OpenSans', color: Colors.black),
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  brand = "INFC";
                                  namabrand = "Comforta";
                                  setState(() {
                                    loading = true;
                                  });
                                  showfoto();
                                },
                                child: const Text(
                                  'Comforta',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  brand = "INFX";
                                  namabrand = "Comforta X";
                                  showfoto();
                                },
                                child: const Text(
                                  'Comforta X',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  brand = "INFS";
                                  namabrand = "Spring Air";
                                  showfoto();
                                },
                                child: const Text(
                                  'Spring Air',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  brand = "INFT";
                                  namabrand = "Theraphedic";
                                  showfoto();
                                },
                                child: const Text(
                                  'Theraphedic',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  brand = "INFF";
                                  namabrand = "Superfit";
                                  showfoto();
                                },
                                child: const Text(
                                  'Super Fit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))),
              SizedBox(
                height: 5,
              ),
              Text(
                'Filter Jenis :',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'OpenSans', color: Colors.black),
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  minimumSize: Size(100, 35),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  listModel.clear();
                                  srp = "1";
                                  showjenis();
                                },
                                child: const Text(
                                  'Kasur',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  minimumSize: Size(100, 35),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  listModel.clear();
                                  srp = "2";
                                  showjenis();
                                },
                                child: const Text(
                                  'Divan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  minimumSize: Size(100, 35),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  listModel.clear();
                                  srp = "3";
                                  showjenis();
                                },
                                child: const Text(
                                  'Sandaran',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                  minimumSize: Size(100, 35),
                                  // Foreground color
                                  onPrimary: Colors.white,
                                  // Background color
                                  primary: primaryColor,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(1.0)),
                                onPressed: () {
                                  listModell.clear();
                                  listModel.clear();
                                  srp = "9";
                                  showjenis();
                                },
                                child: const Text(
                                  'Aksesoris',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ))),
              Expanded(
                  child: ListView.builder(
                itemCount: model.length,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, playerIndex) {
                  final nDataList = model[playerIndex];
                  no = model.last.nosp;
                  id = model.last.id.toString();

                  return Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                      //   Text(
                      //     "No SP :" + model.last.nosp,
                      //     style: TextStyle(color: Colors.black, fontSize: 18),
                      //   ),
                      // ],
                      );
                },
              )),
              Text(
                'Promo yang sedang berjalan :',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'OpenSans', color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0.2, 0.5),
                              blurRadius: 10.0)
                        ]),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/kasur.png',
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/kasur.png',
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/kasur.png',
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/kasur.png',
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 10,
                  child:
                      // loading
                      //     ? Center(child: CircularProgressIndicator())
                      //     :
                      GridView.builder(
                    shrinkWrap: true,
                    itemCount: listModell.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                        key: ValueKey(listModell[index].id),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                // width: 200,
                                // height: 150,
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(10)),
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.black26,
                                //       blurRadius: 10.0,
                                //       offset: Offset(0.0, 5.0),
                                //     ),
                                //   ],
                                // ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.asset(
                                          'assets/kasur.png',
                                          width: 45.0,
                                          height: 45.0,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      //  width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1,
                                            child: listModell[index].imdsc2 ==
                                                    null
                                                ? Text(
                                                    listModell[index]
                                                            .IMDSC1
                                                            .toString() +
                                                        " ",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  )
                                                : Text(
                                                    listModell[index]
                                                            .IMDSC1
                                                            .toString() +
                                                        " " +
                                                        listModell[index]
                                                            .imdsc2
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Stok>5",
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(children: [
                                            Text(
                                              namabrand.toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              width: 10,
                                              height: 10,
                                              padding: EdgeInsets.fromLTRB(
                                                  50, 0, 0, 20),
                                              child: FavoriteButton(
                                                isFavorite: false,
                                                // iconDisabledColor: Colors.white,
                                                valueChanged: (_isFavorite) {
                                                  print(
                                                      'Is Favorite : $_isFavorite');
                                                },
                                                iconSize: 30,
                                              ),
                                            ),
                                          ])
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // width: 70,
                              ),
                            ],
                          ),
                          onTap: () {
                            item = listModell[index].imlitm.toString();
                            nma = listModell[index].IMDSC1.toString();
                            desc2 = listModell[index].imdsc2.toString();
                            // create();
                            Saveproduk(item, nma, desc2, brand, namabrand);
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => detailproduk(
                                          code: listModell[index].limcu,
                                          desc: listModell[index].IMDSC1,
                                          nama: namabrand,
                                          desc2: listModell[index].imdsc2,
                                          codebrand: listModell[index].imglpt,
                                          brands: listModell[index].imlitm,
                                          // invoice: widget.invoice
                                        )));
                          },
                        )),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  )),
              Expanded(
                  child:
                      // loading
                      //     ? Center(child: CircularProgressIndicator())
                      //     :
                      GridView.builder(
                shrinkWrap: true,
                itemCount: listModel.length,
                itemBuilder: (BuildContext context, int index) => Card(
                    key: ValueKey(listModel[index].id),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 60,
                                    child: Image.asset(
                                      'assets/kasur.png',
                                      width: 45.0,
                                      height: 45.0,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  //  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        child: listModel[index].imdsc2 == null
                                            ? Text(
                                                listModel[index]
                                                        .IMDSC1
                                                        .toString() +
                                                    " ",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              )
                                            : Text(
                                                listModel[index]
                                                        .IMDSC1
                                                        .toString() +
                                                    " " +
                                                    listModel[index]
                                                        .imdsc2
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Stok>5",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(children: [
                                        Text(
                                          namabrand.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 10,
                                          height: 10,
                                          padding:
                                              EdgeInsets.fromLTRB(50, 0, 0, 20),
                                          child: FavoriteButton(
                                            isFavorite: false,
                                            // iconDisabledColor: Colors.white,
                                            valueChanged: (_isFavorite) {
                                              print(
                                                  'Is Favorite : $_isFavorite');
                                            },
                                            iconSize: 30,
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // width: 70,
                          ),
                        ],
                      ),
                      onTap: () {
                        item = listModell[index].imlitm.toString();
                        nma = listModell[index].IMDSC1.toString();
                        desc2 = listModell[index].imdsc2.toString();
                        // create();
                        Saveproduk(item, nma, desc2, brand, namabrand);
                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => detailproduk(
                                      code: listModell[index].limcu,
                                      desc: listModell[index].IMDSC1,
                                      nama: namabrand,
                                      desc2: listModell[index].imdsc2,
                                      codebrand: listModell[index].imglpt,
                                      brands: listModell[index].imlitm,
                                      // invoice: widget.invoice
                                    )));
                      },
                    )),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
              ))
            ])));
  }
}
