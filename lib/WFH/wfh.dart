// ignore_for_file: file_names, unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alitamsniosmobile/Screendone/attendancedone.dart';
import 'package:alitamsniosmobile/WFH/wfhdone.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/pages/checkindone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;

class Datacheck {
  final String name;
  final String status;
  final String office;
  final String image;
  final bool chex;

  Datacheck(
      {required this.name,
      required this.chex,
      required this.status,
      required this.office,
      required this.image});

  factory Datacheck.fromJson(Map<String, dynamic> json) {
    return Datacheck(
        name: json['name'],
        status: json['status'],
        office: json['office_name'],
        chex: json['chex_out'],
        image: json['image_url']);
  }
}

class WFH extends StatefulWidget {
  @override
  _WFHState createState() => _WFHState();
}

// ignore: camel_case_types
class _WFHState extends State<WFH> {
  var locationMessage = "";
  var lat = " ";
  var lng = " ";
  Position? posisition;
  File? _image;
  final picker = ImagePicker();
  // String idloc = '';
  // String latt = " ";
  // String long = '';
  // String nameloc = '';
  DateTime now = DateTime.now();
  String status = 'WFH';
  late SharedPreferences sharedPreferences;
  String username = '';
  int? showid;
  String phone = '';
  int? compny;
  String stts = '';
  String id = "";
  final Geolocator geolocator = Geolocator();
  String _currentAddress = "";
  bool loading = true;
  bool _visible = false;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    username = prefs.getString('name')!;
    showid = prefs.getInt('id')!;
    phone = prefs.getString('phone')!;
    // nameloc = '${widget.data.name}';
    // idloc = '${widget.data.id}';
    // latt = '${widget.data.latitude}';
    // long = '${widget.data.longitude}';

    //print("lokasi ="+ latt);
    setState(() {
      finalname = username;
    });
    //image.load(showimage);
    // print(finalname);
    // print(showid);
    return username;
  }

  void initState() {
    super.initState();
    _getCurrentLocation();
    choiceImage();
    // getPref(lat);
  }

  getPref(lat) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      var stts = preferences.getString("latitude_user");
    });
    await preferences.setString('latitude_user', lat);
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        posisition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          posisition!.latitude, posisition!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future choiceImage() async {
    final pickedImage = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 1,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  // Future<Datacheck> create() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return String
  //   username = prefs.getString('name')!;
  //   showid = prefs.getInt('id')!;
  //   phone = prefs.getString('phone')!;
  //   posisition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   lat = '${posisition!.latitude}';
  //   lng = '${posisition!.longitude}';
  //   compny = prefs.getInt('company_id')!;
  //   final response = await http.post(
  //       Uri.parse("https://alita.massindogroup.com/api/v1/attendances"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'name': username,
  //         'user_id': showid.toString(),
  //         'longitude_user': lng,
  //         'latitude_user': lat,
  //         'status': status,
  //         'location': _currentAddress,
  //         '_in': now.toString(),
  //         '_version': "i.v2",
  //         'phone': phone,
  //       }));
  //   if (response.statusCode == 200) {
  //     getPref(lat);
  //     print("Berhasil input");
  //     print(response.body);
  //     Navigator.push(
  //         context, new MaterialPageRoute(builder: (context) => wfhdone()));

  //     return Datacheck.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception(response.statusCode);
  //   }
  // }

  Future upload(File imageFile) async {
    id = showid.toString();
    posisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var uri = Uri.parse("https://alita.massindo.com/api/v1/attendances");
    lat = '${posisition!.latitude}';
    lng = '${posisition!.longitude}';
    var request = http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['attendance[name]'] = username;
    request.fields['attendance[user_id]'] = id;
    // request.fields['attendance[longitude_work_place]'] = long;
    // request.fields['attendance[latitude_work_place]'] = latt;
    // request.fields['attendance[work_place_id]'] = idloc;
    // request.fields['attendance[office_name]'] = nameloc;
    request.fields['attendance[longitude_user]'] = lng;
    request.fields['attendance[latitude_user]'] = lat;
    request.fields['attendance[status]'] = status;
    request.fields['attendance[location]'] = _currentAddress;
    request.fields['attendance[attendance_in]'] = now.toString();
    request.fields['attendance[phone]'] = phone;
    request.fields['attendance[attendance_version]'] = "i.v2";
    var pic = await http.MultipartFile.fromPath(
      "attendance[image]",
      imageFile.path,
    );

    //var pic = http.MultipartFile("image",stream,length,filename: basename(imageFile.path));

    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      getPref(lat);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => wfhdone()));
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Anda Berhasil Check In",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
      print("image uploaded");
    } else {
      print("uploaded faild");
    }
  }

  Widget build(BuildContext context) {
    getStringValuesSF();

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 80,
          title: Text(
            "Check In WFH",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70),
                ),
                gradient: LinearGradient(
                    colors: [Colors.lightBlue.shade100, Colors.blue.shade300],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
        ),
        body: SingleChildScrollView(
          // color: Colors.black45,
          //   width: double.infinity,
          //   height: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    size: 50.0,
                  ),
                  onPressed: () {
                    choiceImage();
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                ),
                Container(
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 300,
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(20)),
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black26,
                            //       blurRadius: 10.0,
                            //       offset: Offset(0.0, 5.0),
                            //     ),
                            //   ],
                            // ),
                            child: _image == null
                                ? Text(
                                    'No image',
                                    textAlign: TextAlign.center,
                                  )
                                : Image.file(_image!),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: !_visible,
                            child: Container(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                elevation: 5.0,
                                child: Text('Upload Image'),
                                onPressed: () {
                                  upload(_image!);
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return AlertDialog(
                                  //         title: Text("Tunggu"),
                                  //         content:
                                  //             Text('Sedang Proses Upload'),
                                  //       );
                                  //     });
                                },
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          ),
        ));
  }
}
