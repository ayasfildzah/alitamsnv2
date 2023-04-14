import 'dart:convert';

import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/print/pdfresult.dart';
import 'package:alitamsniosmobile/print/printshow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// String? nopesan, almt, pemb, kirm, or;
int? price, idmat, idorder;
String? pembeli, alamat, order, kirim, pemesan;
double? totalamount;

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

class cekpesanan extends StatefulWidget {
  final String pesan;
  final String Pembeli;
  final String Alamat;
  final String Kirim;
  final String Order;
  final String brand;
  final String Pemesan;

  const cekpesanan({
    Key? key,
    required this.pesan,
    required this.Pembeli,
    required this.Alamat,
    required this.Kirim,
    required this.Order,
    required this.brand,
    required this.Pemesan,
  }) : super(key: key);
  @override
  State<cekpesanan> createState() => _cekpesananState();
}

class _cekpesananState extends State<cekpesanan> {
  Future<List<orderdetails>>? futureData;
  List<orderdetails> detail = [];
  List<alamatmodel> listModel = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    show();
    showdetails();
    futureData = showdetails();

    // print("nama pem = " + totalamount);
  }

  Future<List<alamatmodel>> show() async {
    print("nama = " + widget.pesan);

    final response =
        await http.get("https://alita.massindo.com/api/v1/order_letters");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["result"] as List;
      var filteredList;
      filteredList = rest.where((val) => val["no_sp"] == widget.pesan);

      listModel = filteredList
          .map<alamatmodel>((parsedJson) => alamatmodel.fromJson(parsedJson))
          .toList();
      print(filteredList);
      return listModel;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  // Future<List<orderdetails>?> showdetails() async {
  //   print("nama = " + widget.pesan);
  //   try {
  //     final response = await http
  //         .get("https://alita.massindogroup.com/api/v1/order_letter_details");

  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       var rest = data["result"] as List;
  //       var filteredList;
  //       filteredList = rest.where((val) => val["no_sp"] == "220801BDA0");

  //       details = filteredList
  //           .map<orderdetails>(
  //               (parsedJson) => orderdetails.fromJson(parsedJson))
  //           .toList();
  //       // return details;
  //     } else {
  //       print("Error getting user.");
  //     }
  //   } catch (e) {
  //     print("Error getting user.");
  //   }
  // }

  Future<List<orderdetails>> showdetails() async {
    print("number2 = " + widget.pesan);
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/order_letter_details');
    if (jsonResponse.statusCode == 200) {
      var data = json.decode(jsonResponse.body);
      var rest = data["result"] as List;
      var filter;
      filter = rest.where((val) => val["no_sp"] == widget.pesan);

      detail = filter
          .map<orderdetails>((parsedJson) => orderdetails.fromJson(parsedJson))
          .toList();
      // print(filteredList);
      return detail;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue.shade900,
        onPressed: () async {
          final pdfFile = await PdfInvoiceApi.generate(
              al: alamat,
              nosp: widget.pesan,
              pem: pembeli,
              pesan: pemesan,
              or: order,
              total: totalamount!.toDouble(),
              kir: kirim);
          FileHandleApi.openFile(pdfFile);
        },
        child: Icon(Icons.picture_as_pdf),
      ),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Rincian Pesanan'),
                ],
              ),
            )
          ],
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder<List<alamatmodel>>(
              future: show(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<alamatmodel>? listModel = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      // padding: EdgeInsets.only(top: 20),
                      itemCount: listModel!.length,
                      itemBuilder: (BuildContext context, int playerIndex) {
                        if (listModel[playerIndex].nosp == widget.pesan) {
                          idorder = listModel[playerIndex].id;
                          pembeli = listModel[playerIndex].cusnama.toString();
                          pemesan = listModel[playerIndex].pengirim.toString();
                          alamat = listModel[playerIndex].alamat.toString();
                          kirim = listModel[playerIndex].date.toString();
                          order = listModel[playerIndex].order.toString();
                          totalamount = listModel[playerIndex].total;

                          final currencyFormatter = NumberFormat('#,##0', 'ID');
                          print(currencyFormatter
                              .format(totalamount)); // 100.286.020.524,17

                          return Container(
                              width: MediaQuery.of(context).size.width / 1,
                              padding: EdgeInsets.all(10),
                              // decoration: BoxDecoration(
                              //     // shape: BoxShape.circle,
                              //     color: Colors.white,
                              //     boxShadow: const [
                              //       BoxShadow(
                              //         color: Colors.black,
                              //       )
                              //     ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ALAMAT TUJUAN  : ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            listModel[playerIndex]
                                                .tlpn
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              pembeli!,
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.6,
                                            child: Text(
                                              alamat!,
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.5,
                                        child: Text(
                                          "No Sp : " +
                                              listModel[playerIndex].nosp,
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.blue),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Total Pesanan :",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Rp. " +
                                              currencyFormatter
                                                  .format(totalamount),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                  // SizedBox(
                                ],
                              ));
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
            flex: 1,
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Pengirim  : " + widget.Pemesan,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: FutureBuilder<List<orderdetails>>(
              future: showdetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<orderdetails>? data = snapshot.data;
                  return ListView.builder(
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      // padding: EdgeInsets.only(top: 20),
                      itemCount: data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final currencyFormatter = NumberFormat('#,##0', 'ID');
                        if (data[index].nosp == widget.pesan) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.grey.shade50,
                              elevation: 10,
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            data[index].desc1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('x' +
                                                  data[index].qty.toString()),
                                              Text(
                                                "Rp. " +
                                                    currencyFormatter.format(
                                                        data[index].unitprice),
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          subtitle: new Text(widget.brand),
                                          leading: Image.asset(
                                            'assets/kasur.png',
                                            // width: 250.0,
                                            // height: 250.0,
                                          ),
                                        ),
                                      ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ]));
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
            flex: 4,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Waktu Pemesanan  : ",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        widget.Order,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Waktu Pengiriman  : ",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        widget.Kirim,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
