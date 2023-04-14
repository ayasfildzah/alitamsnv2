// ignore_for_file: file_names, unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alitamsniosmobile/Screendone/attendancedone.dart';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/pages/checkindone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalname;
enum OptionOff { Tukar, Off }

class display {
  String name,
      reason,
      note,
      longitude_user,
      latitude_user,
      status,
      location,
      attendance_in;
  int user_id;

  display(
      {required this.name,
      required this.reason,
      required this.note,
      required this.longitude_user,
      required this.latitude_user,
      required this.status,
      required this.location,
      required this.attendance_in,
      required this.user_id});

  factory display.fromJson(Map<String, dynamic> parsedJson) {
    return display(
      name: parsedJson['name'],
      reason: parsedJson["reason"],
      note: parsedJson["note"],
      longitude_user: parsedJson['longitude_user'],
      latitude_user: parsedJson["latitude_user"],
      status: parsedJson["status"],
      location: parsedJson['location'],
      attendance_in: parsedJson["attendance_in"],
      user_id: parsedJson["user_id"],
    );
  }
}

class formoff extends StatefulWidget {
  // final data;
  // formoff(this.data);

  @override
  _formoffState createState() => _formoffState();
}

// ignore: camel_case_types
class _formoffState extends State<formoff> {
  TextEditingController form = TextEditingController();
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
  String ket = "";
  DateTime now = DateTime.now();
  String status = 'Off';
  late SharedPreferences sharedPreferences;
  String username = '';
  int? showid;
  String phone = '';
  String stts = '';
  String id = "";
  final Geolocator geolocator = Geolocator();
  String _currentAddress = "";
  final bool value = false;
  int val = 1;
  OptionOff _off = OptionOff.Tukar;
  String radioitem = '';
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
    getPref();
  }

  getPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      var stts = preferences.getString("status");
    });
    await preferences.setString('status', stts);
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
      imageQuality: 10,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future<display?> create() async {
    id = showid.toString();
    final response = await http.post(
        Uri.parse("https://alita.massindo.com/api/v1/attendances"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': username,
          'user_id': id,
          'reason': radioitem,
          'note': form.value.text,
          'longitude_user': lng,
          'latitude_user': lat,
          'status': status,
          'location': _currentAddress,
          'attendance_in': now.toString(),
        }));

    if (response.statusCode == 200) {
      print("Berhasil input");
      var result = jsonDecode(response.body);
      print(result);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => MyDashboard()));

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selamat Data Berhasil di Input")));
      return display.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  // Future upload(File imageFile) async {

  //   posisition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var uri = Uri.parse("https://alita.massindo.com/api/v1/attendances");
  //   lat = '${posisition!.latitude}';
  //   lng = '${posisition!.longitude}';
  //   var request = http.MultipartRequest("POST", uri);
  //   Map<String, String> headers = {
  //     'Content-Type': 'multipart/form-data',
  //   };
  //   request.headers["Content-Type"] = 'multipart/form-data';
  //   request.fields['attendance[name]'] = username;
  //   request.fields['attendance[user_id]'] = id;
  //   // request.fields['attendance[longitude_work_place]'] = long;
  //   // request.fields['attendance[latitude_work_place]'] = latt;
  //   // request.fields['attendance[work_place_id]'] = idloc;
  //   request.fields['attendance[reason]'] = radioitem;
  //   request.fields['attendance[note]'] = form.value.text;
  //   request.fields['attendance[longitude_user]'] = lng;
  //   request.fields['attendance[latitude_user]'] = lat;
  //   request.fields['attendance[status]'] = status;
  //   request.fields['attendance[location]'] = _currentAddress;
  //   request.fields['attendance[attendance_in]'] = now.toString();

  //   var pic = await http.MultipartFile.fromPath(
  //     "attendance[image]",
  //     imageFile.path,
  //   );

  //   //var pic = http.MultipartFile("image",stream,length,filename: basename(imageFile.path));

  //   request.files.add(pic);
  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     Navigator.pushReplacement(
  //         context, new MaterialPageRoute(builder: (context) => MyDashboard()));

  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Selamat Data Berhasil di Input")));
  //   } else {
  //     print("uploaded faild");
  //   }
  // }

  Widget build(BuildContext context) {
    getStringValuesSF();

    // print(_currentAddress);
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
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
                      Text('Form OFF'),
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
          body: SingleChildScrollView(
            //   width: double.infinity,
            //   height: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                        "Mohon Periksa Kembali dan Isi Dengan Teliti : ",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 50),
                  Container(
                    child: Text("Alasan : ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RadioListTile(
                        groupValue: radioitem,
                        title: Text('Tukar Jadwal Kerja'),
                        value: 'Tukar Jadwal Kerja',
                        onChanged: (val) {
                          setState(() {
                            radioitem = val.toString();
                            print(radioitem);
                          });
                        },
                      ),
                      RadioListTile(
                        groupValue: radioitem,
                        title: Text('Tukar Jadwal Off'),
                        value: 'Tukar Jadwal Off',
                        onChanged: (val) {
                          setState(() {
                            radioitem = val.toString();
                            print(radioitem);
                          });
                        },
                      ),
                      // ListTile(
                      //   title: Text("Tukar Jadwal Kerja"),
                      //   leading: Radio(
                      //     value: OptionOff.Tukar,
                      //     groupValue: _off,
                      //     onChanged: (OptionOff? value) {
                      //       setState(() {
                      //         _off = value!;
                      //         print(_off);
                      //       });
                      //     },
                      //     activeColor: Colors.blue,
                      //     // toggleable: true,
                      //   ),
                      // ),
                      // ListTile(
                      //   title: Text("Tukar Jadwal Off"),
                      //   leading: Radio(
                      //     value: OptionOff.Off,
                      //     groupValue: _off,
                      //     onChanged: (OptionOff? value) {
                      //       setState(() {
                      //         _off = value!;
                      //       });
                      //       print(value);
                      //     },
                      //     activeColor: Colors.blue,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text("Keterangan : ",
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 16),
                      textAlign: TextAlign.left),
                  SizedBox(height: 10.0),
                  TextFormField(
                    onSaved: (e) => ket = e!,
                    controller: form,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Alasan Mengajukan Off'),
                  ),
                  // SizedBox(height: 5.0),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.photo_camera_rounded,
                  //       size: 50.0,
                  //     ),
                  //     onPressed: () {
                  //       choiceImage();
                  //       setState(() {
                  //         _visible = !_visible;
                  //       });
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      elevation: 5.0,
                      child: Text('Submit'),
                      onPressed: () {
                        create();
                        // upload(_image!);
                        setState(() {
                          _visible = !_visible;
                        });
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: Text("Tunggu"),
                        //         content: Text(
                        //             'Sedang Proses Upload'),
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
                ],
              ),
            ),
          )),
    );
  }
}
