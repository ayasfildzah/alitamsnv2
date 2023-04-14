import 'dart:convert';
import 'dart:io';

import 'package:alitamsniosmobile/Scan/Scanner.dart';
import 'package:alitamsniosmobile/homecheckin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class checkdisplay extends StatefulWidget {
  final Map jsondata;

  const checkdisplay({Key? key, required this.jsondata}) : super(key: key);

  @override
  _checkdisplayState createState() => _checkdisplayState();
}

class _checkdisplayState extends State<checkdisplay> {
  final TextEditingController formserial = TextEditingController();
  final TextEditingController formitem = TextEditingController();
  final TextEditingController formket = TextEditingController();
  String serial = "";
  String item = "";
  String ket = "";
  bool isChecked = false;
  String checked = "Kondisi Barang Baik";
  bool _visible = false;
  File? _image;
  String result = " ";
  String result2 = " ";

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

  Future _buildQrView2(BuildContext context) async {
    final results = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => Scanner()));
    result2 = results;

    setState(() {
      result2 = results;
    });
    print("hasil = " + result2);
    return result2;
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

  Future upload(File imageFile) async {
    String iddisplay = "${widget.jsondata['result']['id']}";
    var uri =
        Uri.parse("https://alita.massindo.com/api/v1/check_display_details");

    var request = http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['check_display_detail[serial_number]'] = result;
    request.fields['check_display_detail[item_number]'] = result2;
    request.fields['check_display_detail[status]'] = checked.toString();
    request.fields['check_display_detail[note]'] = formket.value.text;
    request.fields['check_display_detail[check_display_id]'] = iddisplay;

    print(TextEditingController(text: result2).value.text);

    var pic = await http.MultipartFile.fromPath(
      "check_display_detail[image]",
      imageFile.path,
    );

    //var pic = http.MultipartFile("image",stream,length,filename: basename(imageFile.path));

    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (context) => adddisplay()));
      showAlert(context);
      print("image uploaded");
    } else {
      print(response.statusCode);
    }
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            Text(' Data Berhasil di Input ')
          ]),
          content: Text("Input Lagi ? "),
          actions: <Widget>[
            FlatButton(
              child: Text("Ya"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                Navigator.of(context).pop();
                TextEditingController(text: result).clear();
                TextEditingController(text: result2).clear();

                formket.clear();
                formitem.clear();
                formserial.clear();
              },
            ),
            FlatButton(
              child: Text("Tidak"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => Homecheckin()));
              },
            ),
          ],
        );
      },
    );
  }
  // Future<display?> create() async {
  //   String iddisplay = "${widget.jsondata['result']['id']}";
  //   final response = await http.post(
  //       Uri.parse(
  //           "https://alita.massindogroup.com/api/v1/check_display_details"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'serial_number': formserial.value.text,
  //         'item_number': formitem.value.text,
  //         'status': isChecked.toString(),
  //         'note': formket.value.text,
  //         'check_display_id': iddisplay,
  //       }));

  //   if (response.statusCode == 200) {
  //     print("Berhasil input");
  //     var result = jsonDecode(response.body);
  //     print(result);
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => checkdisplay(jsondata: result)),
  //     // );
  //     return display.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception(response.statusCode);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print("Show = " + "${widget.jsondata['result']['id']}");
    // result = TextEditingController(text: result).text;
    // // _buildQrView(context);
    // print("object= " + TextEditingController(text: result).value.text);

    print("objectt2 = " + checked);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 50,
              title: Text(
                "Check Display Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Colors.lightBlue),
              ),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 15),

                          width: MediaQuery.of(context).size.width / 1,
                          // height: MediaQuery.of(context).size.height / 3,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Serial Number : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.qr_code,
                                      size: 30,
                                    ),
                                    onPressed: () => _buildQrView(context),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    height: 50,
                                    child: TextFormField(
                                      onSaved: (e) => serial = e!,
                                      controller: formserial,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        // labelText: "Serial Number",
                                        hintText: result,
                                      ),
                                      onChanged: (value) {
                                        result = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Text("value_1 : " + result,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Item Number : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.qr_code,
                                      size: 30,
                                    ),
                                    onPressed: () => _buildQrView2(context),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    height: 50,
                                    child: TextFormField(
                                      onSaved: (e) => item = e!,
                                      controller: formitem,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        // labelText: "Item Number",
                                        hintText: result2,
                                      ),
                                      onChanged: (value) {
                                        result2 = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text("value_2 : " + result2,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Status : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      // This is where we update the state when the checkbox is tapped
                                      setState(() {
                                        isChecked = value!;
                                        if (value == true) {
                                          checked = "Tukar Tarik";
                                        } else {
                                          checked = "Kondisi Barang Baik";
                                          print(checked);
                                        }
                                        print(checked);
                                      });
                                    },
                                  ),
                                  Text("Tukar Tarik"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Keterangan : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 50,
                                child: TextFormField(
                                  onSaved: (e) => item = e!,
                                  controller: formket,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Keterangan",
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
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
                              SizedBox(height: 10.0),
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
                                                    BorderRadius.circular(30.0),
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ])),
                            ],
                          ),
                        ),
                      ],
                    )))));
  }
}
