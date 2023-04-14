import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/pages/Check_in.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  String name;
  final int id;
  final String address;
  final double latitude, longitude;
  String image_url;

  Data(
      {required this.name,
      required this.id,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.image_url});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        name: json['name'],
        id: json['id'],
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        image_url: json['image_url']);
  }
}

class pilihlokasi extends StatefulWidget {
  //pilihlokasi({Key key}) : super(key: key);

  @override
  _pilihlokasiState createState() => _pilihlokasiState();
}

class _pilihlokasiState extends State<pilihlokasi> {
  Future<List<Data>>? futureData;
  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;
  late List<Data> listproduk;
  Data? data;
  final String apiURL = 'https://alita.massindo.com/api/v1/work_places?lat=';

  // void getCurrentLocation() async {
  //   posisition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var lasPosition = await Geolocator.getLastKnownPosition();
  //   print(lasPosition);
  //   lat = '${posisition!.latitude}';
  //   lng = '${posisition!.longitude}';
  //
  //    //print('latitude user = ' + lat);
  //   // print('longitude user = ' + lng);
  //   // setState(() {
  //   //   locationMessage = "$posisition";
  //   // });
  // }

  // save(String value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString(data.name, json.encode(value));
  // }

  Future<List<Data>> fetchData() async {
    // getCurrentLocation();
    posisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lasPosition = await Geolocator.getLastKnownPosition();
    // lat = '${posisition!.latitude}';
    // lng = '${posisition!.longitude}';
    // final String apiURL = 'https://alita.massindo.com/api/v1/work_places?lat=';

    print(
        'https://alita.massindo.com/api/v1/work_places?lat=${posisition!.latitude}&long=${posisition!.longitude}');
    var jsonResponse = await http.get(
        'https://alita.massindo.com/api/v1/work_places?lat=${posisition!.latitude}&long=${posisition!.longitude}');
    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
      List<Data> usersList = jsonItems.map<Data>((json) {
        return Data.fromJson(json);
      }).toList();
      print(usersList);
      return usersList;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pilih Lokasi",
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 12,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //  tooltip: "Cancel and Return to List",
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyDashboard()));
            },
          ),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 50.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/choose.png', width: 65, height: 65),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" Klik Tempat Kerja Anda !! ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontSize: 12,
                        )),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Data>>(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data>? data = snapshot.data;
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 100),
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  title: Text(data[index].name,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                  subtitle: Text(data[index].address,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.grey,
                                        fontSize: 10,
                                      )),
                                  leading: Icon(Icons.maps_home_work),
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             Check_in(data[index])));
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                Check_in(data[index])));
                                    // save(data[index].name);
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator.adaptive();
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
