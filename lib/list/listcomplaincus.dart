import 'dart:convert';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/model/complaintmodel.dart';
import 'package:alitamsniosmobile/pages/formcomplaint.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? showid;

class ListComplaintCust extends StatefulWidget {
  @override
  _ListComplaintCustState createState() => _ListComplaintCustState();
}

class _ListComplaintCustState extends State<ListComplaintCust> {
  // Membuat List Dari data Internet
  Color primaryColor = Color(0xff486493);
  List<Complaint> listModel = [];
  var loading = false;
  String username = '';
  String showimage = '';
  String showno = '';
  int? id;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showimage = prefs.getString('image_url')!;
    showno = prefs.getString('phone')!;
    id = prefs.getInt('id');

    setState(() {
      finalname = username;
      username = prefs.getString('name')!;
    });
    //image.load(showimage);
    showid = id.toString();
    return username;
  }

  Future<Null> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');
    setState(() {
      loading = true;
    });

    final responseData = await http.get(
        "https://msn.alita.massindo.com/api/v1/complaintbycreator?creator_id=$id");
    print(
        "https://msn.alita.massindo.com/api/v1/complaintbycreator?creator_id=$id");
    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
          listModel.add(Complaint.fromJson(i));
        }
        loading = false;
      });
    }
  }

  //Panggil Data / Call Data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getStringValuesSF();
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
              padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
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
                    height: 20,
                  ),
                  Text('Complaint', style: TextStyle(fontSize: 18)),
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
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: listModel.length,
                itemBuilder: (context, i) {
                  final nDataList = listModel[i];
                  String date = nDataList.created;
                  DateFormat oldFormat =
                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                  DateFormat newFormat = DateFormat("yyyy-MM-dd");
                  DateFormat jamformat = DateFormat("HH:mm");
                  String dateStr = newFormat.format(oldFormat.parse(date));
                  String showjam = jamformat.format(oldFormat.parse(date));
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
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [primaryColor, primaryColor]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(0.0, 0.3),
                                blurRadius: 15.0)
                          ]),
                      margin: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: nDataList.img.url == null
                                    ? const Icon(
                                        Icons.bed,
                                        color: Colors.lightBlue,
                                        size: 105,
                                      )
                                    : Image.network(nDataList.img.url,
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 180),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        nDataList.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize: 16,
                                            color: Colors.white),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                          nDataList.complaintstatuses +
                                              " -- " +
                                              nDataList.note,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                      Text(
                                          nDataList.category +
                                              " -- " +
                                              nDataList.brand.namebrand +
                                              " -- " +
                                              nDataList.size,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black)),
                                      Text(nDataList.producttype.productname,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black)),
                                      Text("No Sp : " + nDataList.nosp,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black)),
                                      Text("Status : " + nDataList.status,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black)),
                                      Text(
                                        "Tgl Lapor : " +
                                            dateStr +
                                            " Jam " +
                                            showjam,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      Text("---------------------------"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/whatsapp.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("+62" + nDataList.notlpn,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black))
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => formcompaint()));
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}
