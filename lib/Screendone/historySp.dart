import 'dart:convert';

import 'package:alitamsniosmobile/print/pdfresult.dart';
import 'package:alitamsniosmobile/print/printapprove.dart';
import 'package:alitamsniosmobile/print/printshow.dart';
import 'package:http/http.dart' as http;
import 'package:alitamsniosmobile/fragment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class alamatmodel {
  int id;
  String alamat, note, creator;
  double amount;
  String cusnama, nosp, pengirim;
  String date, order;

  alamatmodel({
    required this.id,
    required this.alamat,
    required this.amount,
    required this.cusnama,
    required this.note,
    required this.creator,
    required this.nosp,
    required this.pengirim,
    required this.date,
    required this.order,
  });
  factory alamatmodel.fromJson(Map<String, dynamic> json) => alamatmodel(
        id: json["id"],
        alamat: json["address_ship_to"],
        cusnama: json["ship_to_name"],
        amount: json["extended_amount"],
        note: json["note"],
        creator: json["creator"],
        date: json["request_date"],
        nosp: json["no_sp"],
        pengirim: json["customer_name"],
        order: json["order_date"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "address": alamat,
        "customer_name": cusnama,
        "request_date": date,
        "note": note,
        "extended_amount": amount,
        "no_sp": nosp,
        "order_date": order,
      };
}

class historySp extends StatefulWidget {
  const historySp({Key? key}) : super(key: key);

  @override
  State<historySp> createState() => _historySpState();
}

class _historySpState extends State<historySp> {
  bool loading = false;
  List<alamatmodel> listModel = [];
  final currencyFormatter = NumberFormat('#,##0', 'ID');

  Future<void> show() async {
    setState(() {
      loading = true;
    });
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
          listModel.add(alamatmodel.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

  @override
  void initState() {
    super.initState();
    show();
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
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                      Text(
                        'History SP Saya',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 36,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        // onSaved: (e) => nomor = e!,
                        // controller: formnomor,
                        // onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search",
                          prefixIcon: Icon(Icons.search, color: Colors.black38),
                        ),
                      ),
                    ),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/resume.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width / 1,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: listModel.length,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, playerIndex) {
                final nDataList = listModel[playerIndex];
                String order = nDataList.note.toString();
                if (order == "Pending") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/pendingtext.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        final pdfFile =
                                            await PdfInvoiceApi.generate(
                                                al: nDataList.alamat,
                                                nosp: nDataList.nosp,
                                                pem: nDataList.cusnama,
                                                pesan: nDataList.pengirim,
                                                or: nDataList.order,
                                                total:
                                                    nDataList.amount.toDouble(),
                                                kir: nDataList.date);
                                        FileHandleApi.openFile(pdfFile);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                }
                if (order == "Selesai") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/selesai.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () {
                                        // setState(() {
                                        //   _visible = !_visible;
                                        // });
                                        // popup();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                }
                if (order == "Approved") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/approved.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        final pdfFile =
                                            await PdfInvoiceAproved.generate(
                                                al: nDataList.alamat,
                                                nosp: nDataList.nosp,
                                                pem: nDataList.cusnama,
                                                pesan: nDataList.pengirim,
                                                or: nDataList.order,
                                                total:
                                                    nDataList.amount.toDouble(),
                                                kir: nDataList.date);
                                        FileHandleApi.openFile(pdfFile);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                }
                if (order == "Dikirim") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/dikirim.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () {
                                        // setState(() {
                                        //   _visible = !_visible;
                                        // });
                                        // popup();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                }
                if (order == "Diproses") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/diproses.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () {
                                        // setState(() {
                                        //   _visible = !_visible;
                                        // });
                                        // popup();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                }
                if (order == "Rejected") {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    child: Text(
                                      listModel[playerIndex].cusnama.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Row(children: [
                                    Text(
                                      "No.Sp = ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      nDataList.nosp,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                    )
                                  ]),
                                  nDataList.amount == null
                                      ? const Text(
                                          " ",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Rp." +
                                              currencyFormatter
                                                  .format(nDataList.amount),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/Rejected.png',
                                  ),
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    alignment: Alignment.topRight,
                                    child: MaterialButton(
                                      // minWidth: 100,
                                      height: 25,
                                      elevation: 5.0,
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Color(0xffff0A367E),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )));
                } else {
                  return Container();
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
