import 'dart:convert';

import 'package:alitamsniosmobile/Screendone/shownotif.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String? nosp, descrip1, descrip2;
int? price, idmat, idorder;
String? pembeli, alamat, order, kirim, pemesan;

class alamatmodel {
  int id;
  String alamat, pengirim, tlpn;
  double total;
  String cusnama, nosp;
  String date, order, creator;

  alamatmodel(
      {required this.id,
      required this.alamat,
      required this.cusnama,
      required this.pengirim,
      required this.tlpn,
      required this.total,
      required this.nosp,
      required this.date,
      required this.order,
      required this.creator});
  factory alamatmodel.fromJson(Map<String, dynamic> json) => alamatmodel(
        id: json["id"],
        alamat: json["address_ship_to"],
        cusnama: json["ship_to_name"],
        pengirim: json["customer_name"],
        total: json["extended_amount"],
        tlpn: json["phone"],
        date: json["request_date"],
        nosp: json["no_sp"],
        order: json["order_date"],
        creator: json["creator"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "address": alamat,
        "customer_name": cusnama,
        "request_date": date,
        "no_sp": nosp,
        "order_date": order,
      };
}

class orderdetails {
  int id;
  String desc1;
  String desc2;
  String nosp, item;
  int unitprice, qty;

  orderdetails({
    required this.id,
    required this.desc1,
    required this.desc2,
    required this.nosp,
    required this.unitprice,
    required this.item,
    required this.qty,
  });
  factory orderdetails.fromJson(Map<String, dynamic> json) => orderdetails(
        id: json["id"],
        desc1: json["desc_1"],
        desc2: json["desc_2"],
        nosp: json["no_sp"],
        unitprice: json["unit_price"],
        item: json["item_type"],
        qty: json["qty"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "desc_1": desc1,
        "desc_2": desc2,
        "no_sp": nosp,
        "unit_price": unitprice,
      };
}

class aproval extends StatefulWidget {
  final String nomorsp;
  const aproval({
    Key? key,
    required this.nomorsp,
  }) : super(key: key);

  @override
  State<aproval> createState() => _aprovalState();
}

class _aprovalState extends State<aproval> {
  bool loading = false;
  List<alamatmodel> listModel = [];
  List<orderdetails> details = [];

  Future<alamatmodel?> update() async {
    print("no  =" + idorder.toString());
    final response = await http.put(
        Uri.parse("https://alita.massindo.com/api/v1/order_letters/" +
            idorder.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          // 'extended_amount': '$totalhrga',
          'note': "Approved",
        }));
    print("result = " + response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);

      return alamatmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<alamatmodel>> showdetails() async {
    print("no sp =" + widget.nomorsp);
    var jsonResponse =
        await http.get('https://alita.massindo.com/api/v1/order_letters');
    if (jsonResponse.statusCode == 200) {
      var data = json.decode(jsonResponse.body);
      var rest = data["result"] as List;
      var filter;
      filter = rest.where((val) => val["no_sp"] == widget.nomorsp);

      listModel = filter
          .map<alamatmodel>((parsedJson) => alamatmodel.fromJson(parsedJson))
          .toList();
      print(filter);
      return listModel;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<orderdetails>> show() async {
    print("no sp =" + widget.nomorsp);
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/order_letter_details');
    if (jsonResponse.statusCode == 200) {
      var data = json.decode(jsonResponse.body);
      var rest = data["result"] as List;
      var filter;
      filter = rest.where((val) => val["no_sp"] == widget.nomorsp);

      details = filter
          .map<orderdetails>((parsedJson) => orderdetails.fromJson(parsedJson))
          .toList();
      print(filter);
      return details;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showdetails();
    show();
    print("code = " + widget.nomorsp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => shownotif()));
            },
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(children: [
              Row(
                children: [
                  Image.asset(
                    'assets/mkp.png',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("MASSINDO GROUP"),
                  SizedBox(
                    width: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SURAT PESANAN",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(
                        widget.nomorsp,
                        style: TextStyle(fontSize: 9, color: Colors.blue),
                        textAlign: TextAlign.right,
                      )
                    ],
                  )
                ],
              ),
              Container(
                height: 40,
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder<List<alamatmodel>>(
                  future: showdetails(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<alamatmodel>? data = snapshot.data;
                      return ListView.builder(
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          // padding: EdgeInsets.only(top: 20),
                          itemCount: data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            idorder = data[index].id;
                            // final currencyFormatter = NumberFormat('#,##0', 'ID');
                            if (data[index].nosp == widget.nomorsp) {
                              return Container(
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "PENGAJUAN DISCOUNT DARI",
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Text(
                                        "CUSTOMER",
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Sales",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        data[index].creator,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 47,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pembeli",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            "Standard Disc.",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 100,
                                            child: Text(
                                              data[index].cusnama,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Text(
                                            "0",
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ]),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default show a loading spinner.
                    return CircularProgressIndicator.adaptive();
                  },
                ),
              ),
              Divider(),
              Expanded(
                flex: 5,
                child: FutureBuilder<List<orderdetails>>(
                  future: show(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<orderdetails>? data = snapshot.data;
                      return ListView.builder(
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          // padding: EdgeInsets.only(top: 20),
                          itemCount: data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // final currencyFormatter = NumberFormat('#,##0', 'ID');
                            if (data[index].nosp == widget.nomorsp) {
                              return Container(
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "UNTUK BARANG",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              data[index].desc1 +
                                                  " " +
                                                  data[index].desc2,
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "HARGA SATUAN",
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Rp." +
                                                data[index]
                                                    .unitprice
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "HARGA SETELAH DISCOUNT",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Rp." +
                                                data[index]
                                                    .unitprice
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DISCOUNT YANG DIAJUKAN",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            "0",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.blue,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          Row(children: [
                                            Container(
                                              width: 55,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: MaterialButton(
                                                // minWidth: 100,
                                                height: 20,
                                                elevation: 5.0,
                                                child: Text(
                                                  'Setuju',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 7),
                                                ),
                                                onPressed: () {
                                                  // setState(() {
                                                  //   _visible = !_visible;
                                                  // });
                                                  // popup();
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 50,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: MaterialButton(
                                                // minWidth: 100,
                                                height: 20,
                                                elevation: 5.0,
                                                child: Text(
                                                  'Tolak',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 7),
                                                ),
                                                onPressed: () {
                                                  // setState(() {
                                                  //   _visible = !_visible;
                                                  // });
                                                  // popup();
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                color: Colors.blueGrey.shade200,
                                              ),
                                            ),
                                          ])
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(),
                                ]),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default show a loading spinner.
                    return CircularProgressIndicator.adaptive();
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: MaterialButton(
                    // minWidth: 100,
                    height: 25,
                    elevation: 5.0,
                    child: Text(
                      'Setuju',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    onPressed: () {
                      update();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => shownotif()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Color(0xffff0A367E),
                  ),
                ),
              )
            ])));
  }
}
