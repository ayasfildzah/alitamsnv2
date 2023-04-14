import 'dart:convert';

import 'package:alitamsniosmobile/list/listcomplaincus.dart';
import 'package:alitamsniosmobile/list/listcomplaintsurvey.dart';
import 'package:alitamsniosmobile/pages/complaintupdate.dart';
import 'package:alitamsniosmobile/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Datacheck {
  final String name;
  final String visittime;
  final String visitdate;
  final Images image;
  final String note;
  final String creator;
  final int complaintid;
  final int complaintstatus;
  final int creatorid;
  final String companyid;
  final String created;
  final int id;

  Datacheck(
      {required this.name,
      required this.visittime,
      required this.visitdate,
      required this.note,
      required this.image,
      required this.creator,
      required this.companyid,
      required this.complaintstatus,
      required this.complaintid,
      required this.creatorid,
      required this.created,
      required this.id});

  factory Datacheck.fromJson(Map<String, dynamic> json) {
    return Datacheck(
        name: json['name'],
        visitdate: json['visit_date'],
        visittime: json['visit_time'],
        note: json['note'],
        image: Images.fromJson(json['image']),
        creator: json['creator'],
        creatorid: json['creator_id'],
        companyid: json['company_id'],
        complaintid: json['complaint_id'],
        complaintstatus: json['complaint_status_id'],
        created: json['created_at'],
        id: json['id']);
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

class Complaintdetail extends StatefulWidget {
  String dName, dEmail, dPhone, dCity, dZip, dImg, dId;

  Complaintdetail(
      {required this.dName,
      required this.dEmail,
      required this.dPhone,
      required this.dCity,
      required this.dZip,
      required this.dImg,
      required this.dId});

  @override
  _ComplaintdetailState createState() => _ComplaintdetailState();
}

class _ComplaintdetailState extends State<Complaintdetail> {
  List<Datacheck> listModel = [];
  Color primaryColor = Color(0xff486493);
  var loading = false;

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });

    final responseData = await http.get(
        "https://msn.alita.massindo.com/api/v1/complaint_details?complaint_id=" +
            widget.dId);

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      print(array);
      setState(() {
        for (Map<String, dynamic> i in array) {
          listModel.add(Datacheck.fromJson(i));
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
                              builder: (context) => ListComplaint()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Details of List Survey Schedule',
                      style: TextStyle(fontSize: 18)),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
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
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                widget.dImg == null
                    ? const Icon(
                        Icons.bed,
                        color: Colors.lightBlue,
                        size: 105,
                      )
                    : Image.network(widget.dImg,
                        fit: BoxFit.contain, width: 00, height: 80),
                // Image.network(
                //   widget.dImg,
                //   width: 80,
                //   height: 80,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans"),
                    ),
                    Text(
                      "Creator : ${widget.dEmail}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "OpenSans",
                          color: Colors.white),
                    ),
                    Text("No Tlp : ${widget.dPhone}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            color: Colors.white)),
                    Text("Brand : ${widget.dCity}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            color: Colors.white)),
                    Text("Type : ${widget.dZip}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "OpenSans",
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Progress",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => complaintupdate()));
                      },
                      child: Text(
                        "New Complaint Update",
                        style: TextStyle(
                            fontSize: 18, color: Colors.cyan.shade900),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              // padding: EdgeInsets.all(10),
              // width: double.infinity,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: listModel.length,
                      itemBuilder: (context, i) {
                        final nDataList = listModel[i];
                        String create = nDataList.created;
                        String date = nDataList.visittime;
                        DateFormat oldFormat =
                            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                        DateFormat newFormat = DateFormat("yyyy-MM-dd");
                        DateFormat jamformat = DateFormat("HH:mm");
                        String dateStr =
                            newFormat.format(oldFormat.parse(create));
                        String showjam =
                            jamformat.format(oldFormat.parse(date));
                        String jam = jamformat.format(oldFormat.parse(create));
                        return InkWell(
                          // onTap: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => Complaintdetail(
                          //                 dName: nDataList.name,
                          //                 dEmail: nDataList.creator,
                          //                 dPhone: nDataList.notlpn,
                          //                 dCity: nDataList.brand.namebrand,
                          //                 dZip: nDataList.producttype.productname,
                          //                 dImg: nDataList.img.url,
                          //                 dId: nDataList.id.toString(),
                          //               )));
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
                                  // Container(
                                  //   padding: EdgeInsets.only(top: 10),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(30),
                                  //     child: Image(
                                  //       image:
                                  //           NetworkImage(nDataList.image.url),
                                  //       width: 100,
                                  //       height: 180,
                                  //     ),
                                  //   ),
                                  // ),
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
                                              nDataList.creator,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.4,
                                                height: 85,
                                                child: Text(
                                                  nDataList.name +
                                                      " -- " +
                                                      nDataList.note,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Pelapor : " +
                                                  dateStr +
                                                  " Jam " +
                                                  jam,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Jadwal : " +
                                                  nDataList.visitdate +
                                                  " Jam " +
                                                  showjam,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                                "-------------------------------"),
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
                      })),
        ],
      ),
    );
  }
}
