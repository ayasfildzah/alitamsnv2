import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:alitamsniosmobile/Avaibility/searchallavailibility.dart';
import 'package:alitamsniosmobile/Scan/Scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class display {
  int id;
  String delivnumber;
  String date;
  Images img;

  display(
      {required this.id,
      required this.delivnumber,
      required this.img,
      required this.date});
  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
      id: parsedJson["id"],
      delivnumber: parsedJson["delivery_number"] as String,
      date: parsedJson["created_at"],
      img: Images.fromJson(parsedJson["image"]),
    );
  }
}

class Images {
  String url;

  Images({required this.url});
  factory Images.fromJson(Map<String, dynamic> json) => Images(
        url: json["url"],
      );
  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class documnetdisplay extends StatefulWidget {
  const documnetdisplay({Key? key}) : super(key: key);

  @override
  _documnetdisplayState createState() => _documnetdisplayState();
}

class _documnetdisplayState extends State<documnetdisplay> {
  final TextEditingController formket = TextEditingController();

  String ket = "";
  String result = "";
  QRViewController? controller;
  String value = "";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool loading = false;
  List<display> listmodel = [];
  List<display> model = [];
  int? area;

  Future _buildQrView(BuildContext context) async {
    final results = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => Scanner()));
    result = results;

    setState(() {
      result = results;
    });
    print("hasil2 = " + result);
    return result;
  }

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });
    final responseData = await http.get(
        "https://alita.massindo.com//api/v1/search_document_display?delivery_number=$result");
    print(
        "https://alita.massindo.com//api/v1/search_document_display?delivery_number=$result");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
          listmodel.add(display.fromJson(i));
        }
        loading = false;
      });
    }
  }

  Future<Null> getDataa() async {
    setState(() {
      loading = true;
    });
    String hasil = formket.value.text;
    final responseData = await http.get(
        "https://alita.massindo.com//api/v1/search_document_display?delivery_number=$hasil");
    print("show 2 =" +
        "https://alita.massindo.com//api/v1/search_document_display?delivery_number=$hasil");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      // print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
          listmodel.add(display.fromJson(i));
        }
        loading = false;
      });
    }
  }

  Future<Null> getData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    area = prefs.getInt('area_id');
    setState(() {
      loading = true;
    });
    String hasil = formket.value.text;
    final responseData =
        await http.get("https://alita.massindo.com//api/v1/document_displays");
    print("https://alita.massindo.com//api/v1/document_displays");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
          model.add(display.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getData2();
    getDataa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Display', style: TextStyle(fontSize: 14)),
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
            color: Colors.lightBlue,
          ),
        ),
      ),
      body: Container(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Delivery Number : ",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.qr_code,
                    size: 50,
                  ),
                  onPressed: () => _buildQrView(context),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 50,
                  child: TextFormField(
                    onSaved: (e) => result = e!,
                    controller: formket,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: result,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // ignore: unnecessary_null_comparison
            if (result != null)
              Text('Barcode Data: $result',
                  style: TextStyle(
                    color: Colors.grey,
                  ))
            // else if (result == null)
            //   Text(formket.text)
            else
              const Text('Scan a code'),
            SizedBox(
              height: 5,
            ),
            RaisedButton(
              onPressed: () {
                // ignore: unnecessary_null_comparison
                if (result != null) {
                  getData();
                  result.isEmpty;
                } else {
                  getDataa();
                  formket.clear();
                }
              },
              child: Text("Search",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              color: Colors.lightBlue,
            ),
            Expanded(
              flex: 1,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: listmodel.length,
                      itemBuilder: (context, i) {
                        final nDataList = listmodel[i];
                        String credate = nDataList.date;
                        DateFormat oldFormat =
                            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                        DateFormat newFormat = DateFormat("yyyy-MM-dd");
                        DateFormat jamformat = DateFormat("HH:mm");
                        String dateStr =
                            newFormat.format(oldFormat.parse(credate));
                        String showjam =
                            jamformat.format(oldFormat.parse(credate));
                        return InkWell(
                          // onTap: (){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ListComplaintCustDetail(
                          //     dName: nDataList.name,
                          //     dEmail: nDataList.creator,
                          //     dPhone: nDataList.notlpn,
                          //     dCity: nDataList.brand.namebrand,
                          //     dZip: nDataList.producttype.productname,
                          //   )));
                          // },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0.0, 0.3),
                                      blurRadius: 15.0)
                                ]),
                            margin: EdgeInsets.all(15),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.only(top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: PhotoView(
                                        imageProvider:
                                            NetworkImage(nDataList.img.url),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Delivery Number = " +
                                        nDataList.delivnumber,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                        color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Created at : " +
                                        dateStr +
                                        " Jam " +
                                        showjam,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text("---------------------------"),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                color: Colors.lightBlue,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Image"),
                    SizedBox(width: 60),
                    Text("Delivery Number"),
                    SizedBox(width: 30),
                    Text("Tanggal & Jam")
                  ],
                )),
            Expanded(
              flex: 2,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: model.length,
                      itemBuilder: (context, i) {
                        final nDataList = model[i];
                        String credate = nDataList.date;
                        DateFormat oldFormat =
                            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                        DateFormat newFormat = DateFormat("yyyy-MM-dd");
                        DateFormat jamformat = DateFormat("HH:mm");
                        String dateStr =
                            newFormat.format(oldFormat.parse(credate));
                        String showjam =
                            jamformat.format(oldFormat.parse(credate));
                        return InkWell(
                          // onTap: (){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ListComplaintCustDetail(
                          //     dName: nDataList.name,
                          //     dEmail: nDataList.creator,
                          //     dPhone: nDataList.notlpn,
                          //     dCity: nDataList.brand.namebrand,
                          //     dZip: nDataList.producttype.productname,
                          //   )));
                          // },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  // width: 50,
                                  // height: 50,
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Icon(
                                        Icons.document_scanner,
                                        size: 40,
                                      )
                                      // PhotoView(
                                      //   imageProvider:
                                      //       NetworkImage(nDataList.img.url),
                                      // ),
                                      ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Text(
                                  " - " + nDataList.delivnumber,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 14,
                                      color: Colors.black),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Text(
                                  dateStr + " Jam " + showjam,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      )),
    );
  }
}
