import 'dart:convert';
import 'package:alitamsniosmobile/list/complaindetails.dart';
import 'package:alitamsniosmobile/model/complaintmodel.dart';
import 'package:alitamsniosmobile/pages/formcomplaint.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:alitamsniosmobile/screens/menucomplaint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
String? showid;

class ListComplaint extends StatefulWidget {
  @override
  _ListComplaintState createState() => _ListComplaintState();
}

class _ListComplaintState extends State<ListComplaint> {
  // Membuat List Dari data Internet
  Color primaryColor = Color(0xff486493);
  List<Complaint> listModel = [];
  var loading = false;
  String username = '';
  String showimage = '';
  String showno = '';
  int? id;
  String? dName;

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

    final responseData =
        await http.get("https://msn.alita.massindo.com/api/v1/complaints");

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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => menucomplaint()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('List Survey Schedule', style: TextStyle(fontSize: 18)),
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
                    int idcomplen = nDataList.complaintid;
                    String date = nDataList.created;
                    DateFormat oldFormat =
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                    DateFormat newFormat = DateFormat("yyyy-MM-dd");
                    DateFormat jamformat = DateFormat("HH:mm");
                    String dateStr = newFormat.format(oldFormat.parse(date));
                    String showjam = jamformat.format(oldFormat.parse(date));
                    if (idcomplen == 9) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Complaintdetail(
                                        dName: nDataList.name,
                                        dEmail: nDataList.creator,
                                        dPhone: nDataList.notlpn,
                                        dCity: nDataList.brand.namebrand,
                                        dZip: nDataList.producttype.productname,
                                        dImg: nDataList.img.url,
                                        dId: nDataList.id.toString(),
                                      )));
                        },
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
                                    // ignore: unnecessary_null_comparison
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                fontSize: 18,
                                                color: Colors.blue.shade100),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: 160,
                                            height: 60,
                                            child: Text(
                                                nDataList.complaintstatuses +
                                                    " -- " +
                                                    nDataList.note,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white)),
                                          ),
                                          Text(
                                              nDataList.brand.namebrand +
                                                  " -- " +
                                                  nDataList.size.toString() +
                                                  " -- " +
                                                  nDataList.category.toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Text(
                                              nDataList.producttype.productname,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Text("No Sp : " + nDataList.nosp,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Text("Status : " + nDataList.status,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
                                          Text(
                                            "Tgl Lapor : " +
                                                dateStr +
                                                " Jam " +
                                                showjam,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                          Text(
                                              "-------------------------------"),
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
                                                  color: Colors.white))
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
                    } else {
                      return Container();
                    }
                  })),
    );
  }
}
