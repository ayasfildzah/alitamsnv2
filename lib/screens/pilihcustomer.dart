import 'dart:convert';

import 'package:alitamsniosmobile/Customerbaru/menucutomerbaru.dart';
import 'package:alitamsniosmobile/Salesorder/salesorderbystore.dart';
import 'package:alitamsniosmobile/Screendone/inputpesanan.dart';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/pages/formoff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pilihcustomer extends StatefulWidget {
  const pilihcustomer({Key? key}) : super(key: key);

  @override
  State<pilihcustomer> createState() => _pilihcustomerState();
}

class _pilihcustomerState extends State<pilihcustomer> {
  var buttonsRowDirection = 1; //ROW DIRECTION
  var buttonsColDirection = 2;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAhead = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateorder = TextEditingController();
  String _selected = '';
  String selectbrand = '';
  DateTime? selectedDate;
  List<brand> brands = <brand>[];
  bool _visible = false;
  bool loading = false;
  String title = '';
  String code = '';
  String alamatcus2 = '';
  String nocust = '';
  String namacus = ' ';
  String alamtcus = '';
  String alamat = '';
  String alamat2 = '';
  String code2 = '';
  ValueChanged<DateTime>? selectDate;
  String formattedDate = '';

  @override
  // void date() {
  //   var now = new DateTime.now();
  //   var formatter = DateFormat('yyyy-MM-dd');
  //   formattedDate = formatter.format(now);
  //   print("tgl = " + formattedDate); // 2016-01-25
  // }

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
        // setState(() {
        //   loading = false;
        // });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  Future<display?> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String username = prefs.getString('name')!;
    int area = 2;
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/order_letters"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'customer_name': _typeAhead.text,
          'request_date': dateorder.text,
          'order_date': formattedDate,
          'customer_master': code,
          'address': alamat + alamat2,
          "address_ship_to": alamtcus + alamatcus2,
          "ship_to_code": code2,
          "ship_to_name": _typeAheadController.text,
          'phone': nocust,
          "creator": username,
          // 'image_url':
          //     "https://alita.massindo.com/uploads/work_place/image/1465/1610775319216.png",
        }));
// if (brands.length > 0) {
//       var allValid = true;
//       brands.fo((form) => allValid = allValid && form.isValid());
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);

      return display.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate) selectDate!(picked);
  }

  @override
  void initState() {
    super.initState();
    getSWData();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print("tgl = " + formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home()));
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
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Form(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text("Tambah Customer Baru",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue),
                              textAlign: TextAlign.right),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => menucustomerbaru()));
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Pembeli",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffff0A367E)),
                      ),
                      TypeAheadFormField<brand>(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _typeAheadController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.search), //icon of text field
                                labelText: "Cari pembeli",
                                labelStyle: TextStyle(
                                    fontSize: 12) //label text of field

                                )),
                        suggestionsCallback: (s) => brands.where((c) =>
                            c.abdc.toLowerCase().contains(s.toLowerCase())),
                        itemBuilder: (ctx, users) => Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 2),
                          // height: 10,
                          color: Color(0xff54709E),
                          child: Text(users.abdc,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'OpenSans',
                                  color: Colors.white)),
                        ),
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (users) {
                          _typeAheadController.text = users.abdc;
                          code = users.aban8.toString();
                          alamat = users.aladd1.toString();
                          alamat2 = users.aladd2.toString();
                          // getData(code);
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
              SizedBox(
                height: 10,
              ),
              Form(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dikirim ke, ",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xffff0A367E)),
                        ),
                        TypeAheadFormField<brand>(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAhead,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search), //icon of text field
                                  labelText: "Alamat pembeli",
                                  labelStyle: TextStyle(
                                      fontSize: 12) //label text of field

                                  )),
                          suggestionsCallback: (s) => brands.where((c) =>
                              c.abdc.toLowerCase().contains(s.toLowerCase())),
                          itemBuilder: (ctx, users) => Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 2),
                            // width: 200,
                            color: Color(0xff54709E),
                            child: Text(users.abdc,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white)),
                          ),
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (users) {
                            _typeAhead.text = users.abdc;
                            code2 = users.aban8.toString();
                            nocust = users.abalky.toString();
                            alamtcus = users.aladd1.toString();
                            alamatcus2 = users.aladd2.toString();
                            namacus = users.abdc.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select ';
                            }
                          },
                          onSaved: (value) => selectbrand = value!,
                        ),
                      ],
                    )),
              ),
              // Padding(
              //     padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Tanggal Order, ",
              //           style:
              //               TextStyle(fontSize: 18, color: Color(0xffff0A367E)),
              //         ),
              //         TextField(
              //           controller:
              //               dateinput, //editing controller of this TextField
              //           decoration: InputDecoration(
              //               icon:
              //                   Icon(Icons.calendar_today), //icon of text field
              //               labelText: "Masukan tanggal",
              //               labelStyle:
              //                   TextStyle(fontSize: 12) //label text of field
              //               ),
              //           readOnly:
              //               true, //set it true, so that user will not able to edit text
              //           onTap: () async {
              //             DateTime? pickedDate = await showDatePicker(
              //                 context: context,
              //                 initialDate: DateTime.now(),
              //                 firstDate: DateTime(
              //                     2000), //DateTime.now() - not to allow to choose before today.
              //                 lastDate: DateTime(2101));

              //             if (pickedDate != null) {
              //               print(
              //                   pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              //               String formattedDate =
              //                   DateFormat.yMMMd().format(pickedDate);
              //               print(
              //                   formattedDate); //formatted date output using intl package =>  2021-03-16
              //               //you can implement different kind of Date Format here according to your requirement

              //               setState(() {
              //                 dateinput.text =
              //                     formattedDate; //set output date to TextField value.
              //               });
              //             } else {
              //               print("Date is not selected");
              //             }
              //           },
              //         )
              //       ],
              //     )),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal kirim, ",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffff0A367E)),
                      ),
                      TextField(
                        controller:
                            dateorder, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Masukan tanggal",
                            labelStyle:
                                TextStyle(fontSize: 12) //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat.yMMMd().format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateorder.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Container(
                      //height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1,
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 30),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/resume.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      color: Color(0xffff0A367E),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            offset: Offset(0.2, 0.5),
                                            blurRadius: 10.0)
                                      ]),
                                  child: Text(
                                    'Pilih Barang',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                              onTap: () {
                                // String textSendpemilik =
                                //     _typeAheadController.text;
                                // String textToSendalamat = _typeAhead.text;
                                // String textToSendtgl = dateinput.text;
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Inputpesan(
                                //           pemilik: textSendpemilik,
                                //           alamat: textToSendalamat,
                                //           tgl: textToSendtgl),
                                //     ));
                                create();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Inputpesan()));
                              },
                            ),
                          ]))),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     alignment: Alignment.center,
              //     height: 100.0,
              //     width: double.infinity,
              //     // color: Colors.white,
              //     decoration: BoxDecoration(color: Colors.white, boxShadow: [
              //       BoxShadow(
              //           color: Colors.black.withOpacity(0.4),
              //           offset: Offset(0.2, 0.5),
              //           blurRadius: 10.0)
              //     ]),
              //     child: MaterialButton(
              //       minWidth: 300,
              //       height: 40,
              //       elevation: 5.0,
              //       child: Text(
              //         '+ Keranjang',
              //         style: TextStyle(color: Colors.white, fontSize: 18),
              //       ),
              //       onPressed: () {},
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       color: Color(0xffff0A367E),
              //     ),
              //   ),
              // ),
            ])));
  }
}
