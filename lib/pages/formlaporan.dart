import 'dart:convert';
import 'dart:io';
import 'package:alitamsniosmobile/Surveycomplaint/dashboardcompaint.dart';
import 'package:alitamsniosmobile/homecheckin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? office;

class User {
  int id;
  int workid;
  String name;

  User({required this.id, required this.workid, required this.name});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      workid: parsedJson["work_place_id"],
      name: parsedJson["name"] as String,
    );
  }
}

class books {
  int id;

  String note;
  int workplace;
  String creatorid;

  int attendanceid;
  bool alert;

  int deprtmnid;

  books(
      {required this.id,
      required this.note,
      required this.workplace,
      required this.creatorid,
      required this.attendanceid,
      required this.alert,
      required this.deprtmnid});

  factory books.fromJson(Map<String, dynamic> json) {
    return books(
      id: json['id'],
      note: json['note'],
      workplace: json['work_place_id'],
      alert: json['red_alert'],
      creatorid: json['user_id'],
      attendanceid: json['attendance_id'],
      deprtmnid: json['departement_id'],
    );
  }
}

class laporan extends StatefulWidget {
  const laporan({Key? key}) : super(key: key);

  @override
  _laporanState createState() => _laporanState();
}

class _laporanState extends State<laporan> {
  final TextEditingController formserial = TextEditingController();
  String _mySelection = '';

  List<User> data = [];
  Future<List<User>>? futureuser;
  String serial = "";
  String item = "";
  String ket = "";
  bool isChecked = false;
  String checked = "false";
  bool _visible = false;
  File? _image;
  String brands = "";
  bool loading = true;
  int? id;
  String name = '';
  int? compny;
  String off = '';
  String idshow = '';
  String showoofice = "";

  // Future<books?> create() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   id = prefs.getInt('id')!;
  //   name = prefs.getString('name')!;
  //   compny = prefs.getInt('company_id')!;
  //   print(compny.toString());
  //   final response = await http.post(
  //       Uri.parse("https://alita.massindogroup.com/api/v1/visit_logs"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'user_id': id.toString(),
  //         'note': formserial.value.text,
  //         'work_place_id': "1602",
  //         'attendance_id': idshow,
  //         'departement_id': brands,
  //         'red_alert': "true",
  //       }));
  //   if (response.statusCode == 200) {
  //     print("Berhasil input");
  //     // Navigator.push(
  //     //     context, MaterialPageRoute(builder: (context) => const Books()));
  //     return books.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception(response.statusCode);
  //   }
  // }

  // read() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   off = prefs.getString("nameoffice")!;
  //   // print("nama = " + off);

  //   setState(() {
  //     office = off;
  //   });
  //   return off;
  // }

  Future choiceImage() async {
    final pickedImage = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future upload(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getInt('id')!;
    name = prefs.getString('name')!;
    compny = prefs.getInt('company_id')!;

    var uri = Uri.parse("https://alita.massindo.com/api/v1/visit_logs");

    var request = http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['visit_log[user_id]'] = id.toString();
    request.fields['visit_log[note]'] = formserial.value.text;
    request.fields['visit_log[work_place_id]'] = showoofice;
    request.fields['visit_log[attendance_id]'] = idshow;
    request.fields['visit_log[red_alert]'] = checked;
    request.fields['visit_log[departement_id]'] = brands;

    // print(namaseries + brands + dropdownValue.toString());

    var pic = await http.MultipartFile.fromPath(
      "visit_log[image]",
      imageFile.path,
    );

    //var pic = http.MultipartFile("image",stream,length,filename: basename(imageFile.path));

    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homecheckin()),
      );
      Fluttertoast.showToast(
          msg: "Berhasil di Input",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
    } else {
      print(response.statusCode);
    }
  }

  Future<List<User>> getSWData(idshow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    id = prefs.getInt('id');
    print('https://alita.massindo.com/api/v1/attendances?user_id=$id');
    var jsonResponse = await http
        .get('https://alita.massindo.com/api/v1/attendances?user_id=$id');

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      // var rest = jsonItems["result"] as List;
      List<User> products = jsonItems.map<User>((json) {
        return User.fromJson(json);
      }).toList();
      print("object = " + idshow);
      // print(jsonItems);
      return products;
    } else {
      throw Exception('Failed to load dataabsen from internet');
    }
  }

  @override
  void initState() {
    super.initState();
    futureuser = getSWData(idshow);

    // getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<List<User>>(
                        future: futureuser,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<User>? data = snapshot.data;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: 20),
                                itemCount: data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  idshow = data.first.id.toString();
                                  showoofice = data.first.workid.toString();
                                  getSWData(idshow);
                                  print("objectid = " + showoofice);
                                  return Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.first.name,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ]));
                                });
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          // By default show a loading spinner.
                          return CircularProgressIndicator.adaptive();
                        },
                      ),
                    ),
                    Expanded(
                        flex: 35,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 1.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Catatan Hasil Kunjungan : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1,
                                  height: 100,
                                  child: TextFormField(
                                    onSaved: (e) => serial = e!,
                                    controller: formserial,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Tulis daftar pekerjaan anda",
                                    ),
                                    maxLines: 5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Ditunjukan Kepada  : ",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  child: Column(children: <Widget>[
                                    Container(
                                      child: RadioListTile(
                                        groupValue: brands,
                                        title: Text('Operation',
                                            style: TextStyle(fontSize: 14)),
                                        value: '2',
                                        onChanged: (val) {
                                          setState(() {
                                            brands = val.toString();

                                            print(brands);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: RadioListTile(
                                        groupValue: brands,
                                        title: Text(
                                          'Sales',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: '7',
                                        onChanged: (val) {
                                          setState(() {
                                            brands = val.toString();
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: RadioListTile(
                                        groupValue: brands,
                                        title: Text(
                                          'AFA',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: '6',
                                        onChanged: (val) {
                                          setState(() {
                                            brands = val.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        // This is where we update the state when the checkbox is tapped
                                        setState(() {
                                          isChecked = value!;
                                          if (value == false) {
                                            checked = "false";
                                          } else {
                                            setState(() {
                                              isChecked = true;
                                              checked = "true";
                                              print(checked);
                                            });
                                          }
                                          print(checked);
                                        });
                                      },
                                    ),
                                    Text("Urgent"),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  alignment: Alignment.center,
                                  child: IconButton(
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
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10.0,
                                                  offset: Offset(0.0, 5.0),
                                                ),
                                              ],
                                            ),
                                            child: _image == null
                                                ? Text(
                                                    'No image',
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Image.file(_image!),
                                          ),
                                          SizedBox(height: 20),
                                          Visibility(
                                            visible: _visible,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: MaterialButton(
                                                elevation: 5.0,
                                                child: Text('Upload Image'),
                                                onPressed: () {
                                                  // create();
                                                  upload(_image!);
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ])),
                              ],
                            ),
                          ),
                        )),
                  ],
                ))));
  }
}
