import 'dart:async';
import 'dart:convert';
import 'package:alitamsniosmobile/Screendone/atasanapproval.dart';
import 'package:alitamsniosmobile/backend/constants.dart';
import 'package:alitamsniosmobile/print/cetak.dart';
import 'package:alitamsniosmobile/print/pdfexport.dart';
import 'package:alitamsniosmobile/print/pdfresult.dart';
// import 'package:alitaiosmobile/print/pdfresult.dart';
// import 'package:alitaiosmobile/print/printshow.dart';
import 'package:alitamsniosmobile/print/testprint.dart';
import 'package:alitamsniosmobile/print/printapprove.dart';
import 'package:alitamsniosmobile/screens/pilihcustomer.dart';
import 'package:http/http.dart' as http;
import 'package:alitamsniosmobile/Screendone/inputpesanan.dart';
import 'package:alitamsniosmobile/screens/detailproduk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? nosp, descrip1, descrip2;
int? price, idmat, idorder;
String? pembeli, alamat, order, kirim, pemesan;
List<orderdetails> showmat = [];

class orderdetails {
  int id;
  String desc1;
  String desc2;
  String no_sp;
  int unitprice;

  orderdetails({
    required this.id,
    required this.desc1,
    required this.desc2,
    required this.no_sp,
    required this.unitprice,
  });
  factory orderdetails.fromJson(Map<String, dynamic> json) => orderdetails(
        id: json["id"],
        desc1: json["desc_1"],
        desc2: json["desc_2"],
        no_sp: json["deno_spsc_2"],
        unitprice: json["unit_price"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "desc_1": desc1,
        "desc_2": desc2,
        "no_sp": no_sp,
        "unit_price": unitprice,
      };
}

class alamatmodel {
  int id;
  String alamat, pengirim;
  String cusnama, nosp;
  String date, order;

  alamatmodel({
    required this.id,
    required this.alamat,
    required this.cusnama,
    required this.pengirim,
    required this.nosp,
    required this.date,
    required this.order,
  });
  factory alamatmodel.fromJson(Map<String, dynamic> json) => alamatmodel(
        id: json["id"],
        alamat: json["address_ship_to"],
        cusnama: json["ship_to_name"],
        pengirim: json["customer_name"],
        date: json["request_date"],
        nosp: json["no_sp"],
        order: json["order_date"],
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

class Detailorder extends StatefulWidget {
  final int minValue = 0;
  final int maxValue = 0;

  final String tipebrand;
  const Detailorder({
    Key? key,
    required this.tipebrand,
  }) : super(key: key);
  // final Invoice invoice;
  // const Detailorder({
  //   Key? key,
  //   required this.invoice,
  // }) : super(key: key);
  @override
  State<Detailorder> createState() => _DetailorderState();
}

class _DetailorderState extends State<Detailorder> {
  bool isCheckFD = false;
  int simpleIntInput = 1;
  List<alamatmodel> listModel = [];
  List<orderdetails> details = [];
  List<orderdetails> detail = [];
  List<orderdetails> showdiv = [];
  List<orderdetails> showfd = [];
  orderdetails? orderlist;
  bool loading = false;
  final bool _visible = false;
  bool isCheckmat = false;
  bool isCheckDiv = false;
  TextEditingController formnote = TextEditingController();
  TextEditingController formnote1 = TextEditingController();
  TextEditingController formnote2 = TextEditingController();
  TextEditingController formbrng1 = TextEditingController();
  TextEditingController formbrng2 = TextEditingController();
  TextEditingController formbrng3 = TextEditingController();
  var finalValue = TextEditingController();
  String title = '';
  int _counter = 0;
  int _counter2 = 0;
  int _counter3 = 0;
  String item = " ";
  String desc = "";
  String item1 = " ";
  String desc1 = "";
  String item2 = " ";
  String desc2 = "";
  String desc21 = "";
  String desc22 = "";
  String desc23 = "";
  String brand = "";
  String brand1 = "";
  String brand2 = "";
  String nmabrn = '';
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  int totalhrga = 0;
  int a = 0;
  int? b;
  int? c;
  int sam = 0;
  int sam2 = 0;
  int sam3 = 0;
  String airFlowText = "";
  String velocityText = "";
  String finalText = "";
  // var formatter = NumberFormat('#,##,000');
  List<SPmodel> model = <SPmodel>[];
  String no = '';
  String id = '';
  String srp = '';

  void CurrencyFormat() {
    String convertToIdr(dynamic number, int decimalDigit) {
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: decimalDigit,
      );
      return currencyFormatter.format(number);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      sam = a * _counter;

      print("qty = " + currencyFormatter.format(sam));
    });
  }

  void _minusCounter() {
    setState(() {
      _counter--;

      sam = a * _counter;

      print("qty2 = " + _counter.toString());
    });
  }

  void _incrementCounter2() {
    setState(() {
      _counter2++;
      sam2 = b! * _counter2;
      print("qty = " + currencyFormatter.format(sam));
    });
  }

  void _minusCounter2() {
    setState(() {
      _counter2--;
      sam2 = b! * _counter2;
      print("qty2 = " + _counter.toString());
    });
  }

  void _incrementCounter3() {
    setState(() {
      _counter3++;
      sam3 = c! * _counter3;
      print("qty = " + _counter.toString());
    });
  }

  void _minusCounter3() {
    setState(() {
      _counter3--;
      sam3 = c! * _counter3;
      print("qty2 = " + _counter.toString());
    });
  }

  String totalCalculated() {
    airFlowText = formbrng1.text;
    velocityText = formbrng2.text;
    finalText = formbrng3.text;

    if (airFlowText != '' && velocityText != '' && finalText != '') {
      totalhrga = sam + sam2 + sam3;

      print("object =" + currencyFormatter.format(totalhrga));
    } else if (airFlowText != '' && velocityText != '') {
      totalhrga = sam + sam2;
      print("object1 =" + currencyFormatter.format(totalhrga));
    } else if (airFlowText != '' && finalText != '') {
      totalhrga = sam + sam3;
    } else if (airFlowText != '') {
      totalhrga = sam;
      print("object2 =" + currencyFormatter.format(totalhrga));
    } else if (velocityText != '') {
      totalhrga = sam2;
    } else if (finalText != '') {
      totalhrga = sam3;
      print("object2 =" + currencyFormatter.format(sam));
    } else if (velocityText != '' && finalText != '') {
      totalhrga = sam2 + sam3;
    }
    if (velocityText == '') {
      sam2 = 0;
      _counter2 = 0;
      // totalhrga = sam2;
      print("jml2 = " + currencyFormatter.format(_counter2));
    } else if (airFlowText == '') {
      sam = 0;
      _counter = 0;
      // totalhrga = sam;
      print("jml = " + currencyFormatter.format(sam));
    } else if (finalText == '') {
      sam3 = 0;
      _counter3 = 0;
    }

    return sam.toString();
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, delete);
  }

  startdata() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, showdetails);
  }

  Future<List<orderdetails>> showdetails() async {
    print("number2 = " + desc1 + "no sp =" + no);
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/order_letter_details');
    if (jsonResponse.statusCode == 200) {
      var data = json.decode(jsonResponse.body);
      var rest = data["result"] as List;
      var filter;
      filter = rest.where((val) =>
          val["no_sp"] == no && val["desc_1"] == desc ||
          val["desc_1"] == desc1);

      detail = filter
          .map<orderdetails>((parsedJson) => orderdetails.fromJson(parsedJson))
          .toList();
      // print(filteredList);
      return detail;
    } else {
      throw Exception('Failed to load data from internet');
    }
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

  Future<void> showMat() async {
    http.Response jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/order_letter_details');
    // print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
    //     item);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          showmat.add(orderdetails.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

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

  _selectPlayer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xFF54709E),
            title: Container(
              // decoration: BoxDecoration(
              //     color: Color(0xFF54709E),
              //     borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close, color: Colors.white),
                        backgroundColor: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Pengajuan Discount",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(thickness: 2.5, color: Colors.white),
                      Text("MT. NEO STAR 160 S59 WHITE",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            width: 50,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4.0,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: TextFormField(
                                onSaved: (e) => title = e!,
                                controller: formnote,
                                decoration: InputDecoration(
                                    hintText: "",
                                    hintStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Divider(thickness: 2.5, color: Colors.white),
                          Text("%",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Divider(thickness: 2.5, color: Colors.white),
                          Text(" Atau ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4.0,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: TextFormField(
                                onSaved: (e) => title = e!,
                                controller: formnote,
                                decoration: InputDecoration(
                                    hintText: "",
                                    hintStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          //  minWidth: 200,
                          //height: 40,
                          elevation: 5.0,
                          child: Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xffff0A367E),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  popup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xFF54709E),
            title: Container(
              // decoration: BoxDecoration(
              //     color: Color(0xFF54709E),
              //     borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close, color: Colors.white),
                        backgroundColor: Color(0xffff0A367E),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("No. PO Customer",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        width: MediaQuery.of(context).size.width / 1,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4.0,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                            onSaved: (e) => title = e!,
                            controller: formnote,
                            decoration: InputDecoration(
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Keterangan",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        width: MediaQuery.of(context).size.width / 1,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: TextFormField(
                            onSaved: (e) => title = e!,
                            controller: formnote,
                            decoration: InputDecoration(
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              // showdetails();

                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => cekpesanan(
                                          pesan: no,
                                          Pembeli: pembeli!,
                                          Pemesan: pemesan!,
                                          Alamat: alamat!,
                                          Kirim: kirim!,
                                          Order: order!,
                                          brand: nmabrn)));
                            },
                            child: Text("Lewati ...",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              //minWidth: 100,
                              height: 30,
                              elevation: 5.0,
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Color(0xffff0A367E),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    item = prefs.getString('itemnumber')!;
    desc = prefs.getString('desc1')!;
    item1 = prefs.getString('itemnumber1')!;
    desc1 = prefs.getString('desc4')!;
    item2 = prefs.getString('itemnumber2')!;
    desc2 = prefs.getString('desc3')!;
    desc21 = prefs.getString('desc2')!;
    desc22 = prefs.getString('desc2save')!;
    desc23 = prefs.getString('desc2save2')!;
    brand = prefs.getString('brand')!;
    brand1 = prefs.getString('brandsave')!;
    brand2 = prefs.getString('brandsave2')!;
    nmabrn = prefs.getString('nmabrand')!;
    print("num =" + widget.tipebrand);
  }

  Future<SPmodel?> Update() async {
    print("id = " + currencyFormatter.format(totalhrga));
    final response = await http.put(
        Uri.parse("https://alita.massindo.com/api/v1/order_letters/" +
            idorder.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'extended_amount': '$totalhrga',
          'note': "Pending",
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

  Future<SPmodel?> create() async {
    print("price = " + currencyFormatter.format(a));
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/order_letter_details"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'qty': _counter.toString(),
          'order_letter_id': id,
          'no_sp': no,
          'unit_price': formbrng1.text,
          'item_number': item,
          'desc_1': desc,
          "desc_2": desc21,
          "brand": widget.tipebrand,
          "item_type": currencyFormatter.format(sam),
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

  Future<SPmodel?> createfd() async {
    print("object = " + item);
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/order_letter_details"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'qty': _counter2.toString(),
          'order_letter_id': id,
          'no_sp': no,
          'unit_price': formbrng2.text,
          'item_number': item1,
          'desc_1': desc1,
          "desc_2": desc22,
          "brand": widget.tipebrand,
          "item_type": currencyFormatter.format(sam2),
        }));
    print("result = " + response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(id);

      return SPmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<SPmodel?> creatediv() async {
    print("object = " + item);
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/order_letter_details"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'qty': _counter3.toString(),
          'order_letter_id': id,
          'no_sp': no,
          'unit_price': formbrng3.text,
          'item_number': item2,
          'desc_1': desc2,
          "desc_2": desc23,
          "brand": widget.tipebrand,
          "item_type": currencyFormatter.format(sam3),
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

  Future<bool> delete() async {
    print("id order =" + idmat.toString());
    final response = await http.delete(
      "https://alita.massindo.com/api/v1/order_letter_details/" +
          idmat.toString(),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      print(response);
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    show();
    showSP();
    getStringValuesSF();
    print(widget.tipebrand);
    double number = 7250000.0;
    print("hasil = " + currencyFormatter.format(number));
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
                padding: EdgeInsets.fromLTRB(10, 10, 0, 70),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            removeValues() async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //Remove String
                              prefs.remove("itemnumber");
                              prefs.remove("desc1");
                              prefs.remove("desc2");
                              prefs.remove("desc4");
                              prefs.remove("desc2save");
                              prefs.remove("desc2save2");
                              prefs.remove("itemnumber1");
                              prefs.remove("desc3");
                              prefs.remove("itemnumber2");
                              print("data terhapus");
                            }

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailproduk(
                                          brands: brand,
                                          codebrand: '',
                                          code: '',
                                          desc: desc,
                                          nama: nmabrn,
                                          desc2: '',
                                          // invoice: widget.invoice,
                                        )));
                          },
                        ),
                        Text(
                          'Detail Order',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 120,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
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
            Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: model.length,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, playerIndex) {
                    final nDataList = model[playerIndex];
                    no = model.last.nosp;
                    id = model.last.id.toString();

                    return Container();
                  },
                )),
            Expanded(
              flex: 5,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: 1,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, playerIndex) {
                        final nDataList = listModel[playerIndex];
                        idorder = listModel.last.id;
                        pembeli = listModel.last.cusnama.toString();
                        pemesan = listModel.last.pengirim.toString();
                        alamat = listModel.last.alamat.toString();
                        kirim = listModel.last.date.toString();
                        order = listModel.last.order.toString();

                        return Card(
                            child: InkWell(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                    )
                                  ]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    icon: Icon(
                                      Icons.location_pin,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  pilihcustomer()));
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Pengirim , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              listModel.last.pengirim,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Pembeli , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              pembeli!,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Alamat , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            child: Text(
                                              alamat!,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            "Tanggal Kirim ,",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            kirim!,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          onTap: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     new MaterialPageRoute(
                            //         builder: (context) =>
                            //             detailproduk(listModell[index])));
                          },
                        ));
                      },
                    ),
            ),
            Expanded(
              flex: 20,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 1,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 1, 20, 20),
                            child: Column(
                              children: [
                                desc.isEmpty
                                    ? const Text(
                                        "data",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.2, 0.5),
                                                  blurRadius: 1.0)
                                            ]),
                                        child: Column(children: [
                                          Container(
                                              height: 0,
                                              child: FutureBuilder<
                                                  List<orderdetails>>(
                                                future: showdetails(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    List<orderdetails>?
                                                        details = snapshot.data;
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        // padding: EdgeInsets.only(top: 20),
                                                        itemCount: 1,
                                                        itemBuilder: (BuildContext
                                                                context,
                                                            int playerIndex) {
                                                          final nDataList =
                                                              details![
                                                                  playerIndex];
                                                          print("desc input =" +
                                                              desc +
                                                              no);
                                                          if (details[playerIndex]
                                                                  .desc1 ==
                                                              desc) {
                                                            print(
                                                                "desc input2 =" +
                                                                    desc);
                                                            idmat = details[
                                                                    playerIndex]
                                                                .id;
                                                            print("id input =" +
                                                                idmat
                                                                    .toString());
                                                          }

                                                          return Column();
                                                        });
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "${snapshot.error}");
                                                  }
                                                  // By default show a loading spinner.
                                                  return CircularProgressIndicator
                                                      .adaptive();
                                                },
                                              )),
                                          // Container(
                                          //   height: 0,
                                          //   child: ListView.builder(
                                          //     // itemExtent: 10,
                                          //     shrinkWrap: true,
                                          //     itemCount: 1,
                                          //     physics:
                                          //         const NeverScrollableScrollPhysics(),
                                          //     itemBuilder:
                                          //         (context, playerIndex) {
                                          //       final nDataList =
                                          //           showmat[playerIndex];
                                          //       print("desc input =" + desc);
                                          //       if (nDataList.desc1 == desc) {
                                          //          print("desc input2 =" + desc);
                                          //         idmat = showmat[playerIndex].id;
                                          //         print("id input =" +
                                          //             idmat.toString());
                                          //       }

                                          //       return Container(
                                          //         height: 10,
                                          //       );
                                          //     },
                                          //   ),
                                          // ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: isCheckmat,
                                                onChanged: (value) {
                                                  // This is where we update the state when the checkbox is tapped
                                                  setState(() {
                                                    isCheckmat = value ?? false;
                                                    if (isCheckmat == true) {
                                                      create();
                                                      print("condition true");
                                                      // list();

                                                      startdata();
                                                    } else if (isCheckmat ==
                                                        false) {
                                                      //  startdata();
                                                      print("condition false");
                                                      startTime();
                                                      formbrng1.clear();
                                                    }
                                                  });
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/kasur.png',
                                                    // width: 250.0,
                                                    // height: 250.0,
                                                  ),
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
                                                children: <Widget>[
                                                  SizedBox(height: 20),
                                                  Container(
                                                    width: 120,
                                                    //height: 40,
                                                    child: desc21 == null
                                                        ? Text(
                                                            desc + " ",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            desc + " " + desc21,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                  ),
                                                  Text(widget.tipebrand,
                                                      style: TextStyle(
                                                          fontSize: 10)),
                                                  Container(
                                                    width: 150,
                                                    child: TextField(
                                                      // key: Key(totalCalculated()),
                                                      controller: formbrng1,
                                                      onChanged:
                                                          (textEditingController) {
                                                        setState(() {
                                                          a = int.parse(
                                                              textEditingController
                                                                  .toString());
                                                        });
                                                      },
                                                      onTap: () {
                                                        print("hrg = " +
                                                            formbrng1.text
                                                                .trim());
                                                        setState(() {
                                                          formbrng1.clear();
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Enter Value',
                                                          hintStyle: TextStyle(
                                                              fontSize: 10)
                                                          // labelText: 'Air Flow',
                                                          ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        MaterialButton(
                                                          //minWidth: 50,
                                                          height: 20,
                                                          elevation: 10.0,
                                                          child: Text(
                                                            'Extra Discount',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8),
                                                          ),
                                                          onPressed: () {
                                                            // setState(() {
                                                            //   _visible = !_visible;
                                                            // });
                                                            _selectPlayer();
                                                          },
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          color: Color(
                                                              0xffff0A367E),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black,
                                                                    offset:
                                                                        Offset(
                                                                            0.2,
                                                                            0.5),
                                                                    blurRadius:
                                                                        2.0)
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    _minusCounter();
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 12,
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            3),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            3,
                                                                        vertical:
                                                                            2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                3),
                                                                    color: Colors
                                                                        .white),
                                                                child: Text(
                                                                  '$_counter',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    _incrementCounter();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 12,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text("Catatan",
                                                      style: TextStyle(
                                                          fontSize: 10)),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black,
                                                          blurRadius: 4.0,
                                                          offset: Offset(1, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: TextFormField(
                                                        onSaved: (e) =>
                                                            title = e!,
                                                        controller: formnote1,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                "Masukan catatan",
                                                            hintStyle: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ])),
                                SizedBox(height: 10),
                                desc1.isEmpty
                                    ? const Text(
                                        "no data",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.2, 0.5),
                                                  blurRadius: 1.0)
                                            ]),
                                        child: Column(children: [
                                          Container(
                                              height: 0,
                                              child: FutureBuilder<
                                                  List<orderdetails>>(
                                                future: showdetails(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    List<orderdetails>?
                                                        details = snapshot.data;
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        // padding: EdgeInsets.only(top: 20),
                                                        itemCount: 1,
                                                        itemBuilder: (BuildContext
                                                                context,
                                                            int playerIndex) {
                                                          final nDataList =
                                                              details![
                                                                  playerIndex];
                                                          print("desc input =" +
                                                              desc1);
                                                          if (details[playerIndex]
                                                                  .desc1 ==
                                                              desc1) {
                                                            print(
                                                                "desc input3 =" +
                                                                    desc1);
                                                            idmat = details[
                                                                    playerIndex]
                                                                .id;
                                                            print("id input =" +
                                                                idmat
                                                                    .toString());
                                                          }

                                                          return Column();
                                                        });
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "${snapshot.error}");
                                                  }
                                                  // By default show a loading spinner.
                                                  return CircularProgressIndicator
                                                      .adaptive();
                                                },
                                              )),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                  value: isCheckFD,
                                                  onChanged: (value) {
                                                    // This is where we update the state when the checkbox is tapped
                                                    setState(
                                                      () {
                                                        isCheckFD =
                                                            value ?? false;
                                                        if (isCheckFD == true) {
                                                          createfd();
                                                          print(
                                                              "condition true");
                                                          // list();

                                                          showdetails();
                                                        } else if (isCheckFD ==
                                                            false) {
                                                          // showMat();
                                                          print(
                                                              "condition false");
                                                          formbrng2.clear();
                                                          startTime();
                                                        }
                                                      },
                                                    );
                                                  }),
                                              Image.asset(
                                                'assets/kasur.png',
                                                // width: 250.0,
                                                // height: 250.0,
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(height: 20),
                                                  Container(
                                                    width: 120,
                                                    //height: 40,
                                                    child: desc22 == null
                                                        ? Text(
                                                            desc1 + " ",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            desc1 +
                                                                " " +
                                                                desc22,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                  ),
                                                  Text(nmabrn,
                                                      style: TextStyle(
                                                          fontSize: 10)),
                                                  Container(
                                                    width: 150,
                                                    child: TextField(
                                                      // key: Key(totalCalculated()),
                                                      controller: formbrng2,
                                                      onChanged:
                                                          (textEditingController) {
                                                        setState(() {
                                                          b = int.parse(
                                                              textEditingController
                                                                  .toString());
                                                        });
                                                      },
                                                      onTap: () {
                                                        setState(() {
                                                          formbrng2.clear();
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Enter Value',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          10)),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        MaterialButton(
                                                          //minWidth: 50,
                                                          height: 20,
                                                          elevation: 10.0,
                                                          child: Text(
                                                            'Extra Discount',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8),
                                                          ),
                                                          onPressed: () {
                                                            // setState(() {
                                                            //   _visible = !_visible;
                                                            // });
                                                            _selectPlayer();
                                                          },
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          color: Color(
                                                              0xffff0A367E),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black,
                                                                    offset:
                                                                        Offset(
                                                                            0.2,
                                                                            0.5),
                                                                    blurRadius:
                                                                        2.0)
                                                              ]),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    _minusCounter2();
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 12,
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            3),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            3,
                                                                        vertical:
                                                                            2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                3),
                                                                    color: Colors
                                                                        .white),
                                                                child: Text(
                                                                  '$_counter2',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    _incrementCounter2();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 12,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text("Catatan",
                                                      style: TextStyle(
                                                          fontSize: 10)),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black,
                                                          blurRadius: 4.0,
                                                          offset: Offset(1, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: TextFormField(
                                                        onSaved: (e) =>
                                                            title = e!,
                                                        controller: formnote,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                "Masukan catatan",
                                                            hintStyle: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ]),
                                      ),
                                SizedBox(height: 10),
                                desc2.isEmpty
                                    ? const Text(
                                        "no data",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.2, 0.5),
                                                  blurRadius: 1.0)
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                                height: 0,
                                                child: FutureBuilder<
                                                    List<orderdetails>>(
                                                  future: showdetails(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      List<orderdetails>?
                                                          details =
                                                          snapshot.data;
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          // padding: EdgeInsets.only(top: 20),
                                                          itemCount: 1,
                                                          itemBuilder: (BuildContext
                                                                  context,
                                                              int playerIndex) {
                                                            final nDataList =
                                                                details![
                                                                    playerIndex];
                                                            print(
                                                                "desc input =" +
                                                                    desc2 +
                                                                    no);
                                                            if (details[playerIndex]
                                                                    .desc1 ==
                                                                desc2) {
                                                              print(
                                                                  "desc input2 =" +
                                                                      desc2);
                                                              idmat = details[
                                                                      playerIndex]
                                                                  .id;
                                                              print("id input =" +
                                                                  idmat
                                                                      .toString());
                                                            }

                                                            return Column();
                                                          });
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          "${snapshot.error}");
                                                    }
                                                    // By default show a loading spinner.
                                                    return CircularProgressIndicator
                                                        .adaptive();
                                                  },
                                                )),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                  value: isCheckDiv,
                                                  onChanged: (value) {
                                                    // This is where we update the state when the checkbox is tapped
                                                    setState(() {
                                                      isCheckDiv =
                                                          value ?? false;
                                                      if (isCheckDiv == true) {
                                                        creatediv();
                                                        print("condition true");
                                                        // list();

                                                        // showMat();
                                                      }
                                                      if (isCheckDiv == false) {
                                                        showMat();
                                                        print(
                                                            "condition false");
                                                        formbrng3.clear();
                                                        startTime();
                                                      }
                                                    });
                                                  },
                                                ),
                                                Image.asset(
                                                  'assets/kasur.png',
                                                  // width: 250.0,
                                                  // height: 250.0,
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(height: 20),
                                                    Container(
                                                      width: 120,
                                                      //height: 40,
                                                      child: desc21 == null
                                                          ? Text(
                                                              desc2 + " ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              desc2 +
                                                                  " " +
                                                                  desc23,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                    Text(nmabrn,
                                                        style: TextStyle(
                                                            fontSize: 10)),
                                                    Container(
                                                      width: 150,
                                                      child: TextField(
                                                        // key: Key(totalCalculated()),
                                                        controller: formbrng3,
                                                        onChanged:
                                                            (textEditingController) {
                                                          setState(() {
                                                            c = int.parse(
                                                                textEditingController
                                                                    .toString());
                                                          });
                                                        },
                                                        onTap: () {
                                                          setState(() {
                                                            formbrng3.clear();
                                                          });
                                                        },
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Enter Value',
                                                            hintStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        10)),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MaterialButton(
                                                            //minWidth: 50,
                                                            height: 20,
                                                            elevation: 10.0,
                                                            child: Text(
                                                              'Extra Discount',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8),
                                                            ),
                                                            onPressed: () {
                                                              // setState(() {
                                                              //   _visible = !_visible;
                                                              // });
                                                              _selectPlayer();
                                                            },
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            color: Color(
                                                                0xffff0A367E),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors.white,
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black,
                                                                      offset: Offset(
                                                                          0.2,
                                                                          0.5),
                                                                      blurRadius:
                                                                          2.0)
                                                                ]),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      _minusCounter3();
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 12,
                                                                    )),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              3),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              3,
                                                                          vertical:
                                                                              2),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3),
                                                                      color: Colors
                                                                          .white),
                                                                  child: Text(
                                                                    '$_counter3',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                    onTap: () {
                                                                      _incrementCounter3();
                                                                    },
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 12,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Catatan",
                                                        style: TextStyle(
                                                            fontSize: 10)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.black,
                                                            blurRadius: 4.0,
                                                            offset:
                                                                Offset(1, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                          onSaved: (e) =>
                                                              title = e!,
                                                          controller: formnote2,
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  "Masukan catatan",
                                                              hintStyle: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                              ],
                            ),
                          ),
                        ])
                      ]),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                  height: 80.0,
                  width: double.infinity,
                  // color: Colors.white,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(0.2, 0.5),
                        blurRadius: 10.0)
                  ]),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Total Harga",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Visibility(
                                visible: _visible,
                                child: TextFormField(
                                  key: Key(totalCalculated()),
                                  controller: finalValue,
                                  onChanged: (finaValue) {
                                    setState(() {
                                      // valueFinal = int.parse(finalValue.toString());
                                    });
                                  },
                                  decoration: InputDecoration(
                                      // hintText: 'Enter Value',
                                      // labelText: 'Final Value',
                                      ),
                                  keyboardType: TextInputType.number,
                                )),
                            Text("Rp " + currencyFormatter.format(totalhrga),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      // <-- SEE HERE
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25)),
                                ),
                                builder: (context) {
                                  return SizedBox(
                                      height: 200,
                                      child: Container(
                                        padding: EdgeInsets.all(30.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF54709E),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25.0),
                                                topRight: Radius.circular(25))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Ringkasan Belanja",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(children: [
                                              Text(
                                                "Total harga    ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Visibility(
                                                  visible: _visible,
                                                  child: TextFormField(
                                                    key: Key(totalCalculated()),
                                                    controller: finalValue,
                                                    onChanged: (finaValue) {
                                                      setState(() {
                                                        // valueFinal = int.parse(finalValue.toString());
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter Value',
                                                      labelText: 'Final Value',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  )),
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Text(
                                                  "Rp " +
                                                      currencyFormatter
                                                          .format(totalhrga),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ]),
                                            Row(children: const [
                                              Text(
                                                "Total Diskon Barang",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 48,
                                              ),
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ]),
                                            Divider(
                                                thickness: 2.5,
                                                color: Colors.white),
                                            Row(children: [
                                              Text(
                                                "Total Bayar    ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Visibility(
                                                  visible: _visible,
                                                  child: TextFormField(
                                                    key: Key(totalCalculated()),
                                                    controller: finalValue,
                                                    onChanged: (finaValue) {
                                                      setState(() {
                                                        // valueFinal = int.parse(finalValue.toString());
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter Value',
                                                      labelText: 'Final Value',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  )),
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Text(
                                                  "Rp " +
                                                      currencyFormatter
                                                          .format(totalhrga),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ]),
                                          ],
                                        ),
                                      ));
                                });
                          },
                          icon: Icon(
                            Icons.expand_less,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                          alignment: Alignment.topRight,
                          child: MaterialButton(
                            // minWidth: 100,
                            height: 30,
                            elevation: 5.0,
                            child: Text(
                              'Order',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                Update();
                                // showdetails();
                              });

                              popup();
                              // _selectPlayer2();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Color(0xffff0A367E),
                          ),
                        ),
                      ])),
            ),
          ],
        ));
  }
}

// class list extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         body: Container(
//           height: 10,
//           child: Expanded(
//               child: ListView.builder(
//             itemCount: showmat.length,
//             // physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, playerIndex) {
//               final nDataList = showmat[playerIndex];

//               idmat = showmat.last.id;
//               print("id input =" + idmat.toString());
//               return Column();
//             },
//           )),
//         ),
//       ),
//     );
//   }
// }
