import 'dart:convert';
import 'dart:io';

import 'package:alitamsniosmobile/list/listcomplaincus.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  int id;
  String name;
  String code;

  User({required this.id, required this.name, required this.code});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      code: parsedJson["code"] as String,
    );
  }
}

class books {
  int id;
  String name;
  String notlpn;
  String note;
  int brandid;
  String creatorid;
  String nosp;
  String producttypeid;
  String creator;
  String status;
  int companyid;
  String size;
  String category;
  String complaintstts;
  int areaid;
  String address;
  String image;
  int productseries;

  books(
      {required this.id,
      required this.name,
      required this.notlpn,
      required this.note,
      required this.nosp,
      required this.brandid,
      required this.creatorid,
      required this.producttypeid,
      required this.creator,
      required this.status,
      required this.companyid,
      required this.size,
      required this.category,
      required this.complaintstts,
      required this.areaid,
      required this.address,
      required this.image,
      required this.productseries});

  factory books.fromJson(Map<String, dynamic> json) {
    return books(
      id: json['id'],
      name: json['name'],
      notlpn: json['no_tlpn'],
      note: json['note'],
      nosp: json['no_sp'],
      creator: json['creator'],
      creatorid: json['creator_id'],
      brandid: json['brand_id'],
      producttypeid: json['product_type_id'],
      status: json['status'],
      companyid: json['company_id'],
      size: json['size'],
      category: json['category'],
      complaintstts: json['complaint_statuses'],
      areaid: json['area_id'],
      address: json['address'],
      image: json['image'],
      productseries: json['product_series_id'],
    );
  }
}

class formcompaint extends StatefulWidget {
  const formcompaint({Key? key}) : super(key: key);

  @override
  _formcompaintState createState() => _formcompaintState();
}

class _formcompaintState extends State<formcompaint> {
  TextEditingController formname = TextEditingController();
  TextEditingController formphone = TextEditingController();
  TextEditingController formnosp = TextEditingController();
  TextEditingController formadress = TextEditingController();
  TextEditingController formnote = TextEditingController();

  bool _visible = false;
  String title = '';
  int? page;
  String name = '';
  int? id;
  String number = '';
  String auth = '';
  String radioitem = '';
  String complaint = '';
  String category = '';
  String namaseries = '';
  String series = "";
  String product = "";
  int? area;
  String brands = '';
  int? idcomplaint;
  File? _image;
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();
  static List<User> users = <User>[];
  bool loading = true;
  String? showdata;
  static List<User> products = <User>[];
  String? dropdownValue;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAhead = TextEditingController();

  int? compny;

  List<String> spinnerItems = [
    '90',
    '100',
    '120',
    '140',
    '160',
    '180',
    '200',
  ];

  void setStateIfMounted(f) {
    if (mounted) setState(f);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getInt('id')!;
    name = prefs.getString('name')!;
    compny = prefs.getInt('company_id')!;
    area = prefs.getInt('area_id');
    var uri = Uri.parse("https://msn.alita.massindo.com/api/v1/complaints");

    var request = http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['complaint[name]'] = formname.value.text;
    request.fields['complaint[creator]'] = name;
    request.fields['complaint[creator_id]'] = id.toString();
    request.fields['complaint[note]'] = formnote.value.text;
    request.fields['complaint[product_type_id]'] = product;
    request.fields['complaint[product_series_id]'] = namaseries;
    request.fields['complaint[brand_id]'] = brands;
    request.fields['complaint[complaint_statuses_id]'] = idcomplaint.toString();
    request.fields['complaint[category]'] = category;
    request.fields['complaint[size]'] = dropdownValue;
    request.fields['complaint[complaint_statuses]'] = complaint;
    request.fields['complaint[status]'] = radioitem;
    request.fields['complaint[address]'] = formadress.value.text;
    request.fields['complaint[no_tlpn]'] = formphone.value.text;
    request.fields['complaint[no_sp]'] = formnosp.value.text;
    request.fields['complaint[area_id]'] = area.toString();
    request.fields['complaint[company_id]'] = compny.toString();

    var pic = await http.MultipartFile.fromPath(
      "complaint[image]",
      imageFile.path,
    );

    //var pic = http.MultipartFile("image",stream,length,filename: basename(imageFile.path));

    request.files.add(pic);
    var response = await request.send();
    print("hasil = " + response.toString());

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => ListComplaintCust()));

      print("image uploaded");
    } else {
      print(response.statusCode);
    }
  }

  void getSWData(radioitem) async {
    try {
      final response = await http.get(
          "https://alita.massindo.com/api/v1/product_types?brand_id=$radioitem");
      print(
          "https://alita.massindo.com/api/v1/product_types?brand_id=$radioitem");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['result'] as List;
        //  print(array);
        products =
            array.map<User>((parsedJson) => User.fromJson(parsedJson)).toList();
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  void getUsers() async {
    try {
      final response =
          await http.get("https://alita.massindo.com/api/v1/product_series");
      if (response.statusCode == 200) {
        var user = json.decode(response.body);
        var array = user['result'] as List;
        //  print(array);
        users =
            array.map<User>((parsedJson) => User.fromJson(parsedJson)).toList();
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    getSWData(radioitem);
  }

  Widget row(User user) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.name,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget rowtype(User users) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          users.name,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Form Complaint'),
          centerTitle: true,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 50,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                    colors: [Colors.teal.shade300, Colors.teal.shade200],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "New Customer Service Request",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Masukan Nama Customer : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => title = e!,
                      controller: formname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nama Konsumen",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Masukan Nomor Telephone : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => auth = e!,
                      controller: formphone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "No Hanphone dalam format 08xxxxxxxxxx",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Masukan Nomor Pesanan : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => number = e!,
                      controller: formnosp,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "No. Surat Pesanan",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Address : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => page = e! as int,
                      controller: formadress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Address",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Alasan : ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: radioitem,
                            title: Text(
                              'Open',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Open',
                            onChanged: (val) {
                              setState(() {
                                radioitem = val.toString();
                                idcomplaint = 1;
                                print(idcomplaint);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: radioitem,
                            title: Text(
                              'Sedang Survey',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Sedang Survey',
                            onChanged: (val) {
                              setState(() {
                                radioitem = val.toString();
                                idcomplaint = 7;
                                print(radioitem);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Product Series : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Form(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            TypeAheadFormField<User>(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: _typeAheadController,
                                  decoration: InputDecoration(
                                      hintText: 'Product Series')),
                              suggestionsCallback: (s) => users.where((c) => c
                                  .name
                                  .toLowerCase()
                                  .contains(s.toLowerCase())),
                              itemBuilder: (ctx, data) => Text(data.name,
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'OpenSans')),
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (data) {
                                _typeAheadController.text = data.name;
                                namaseries = data.id.toString();

                                print("series = " + namaseries);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please select a city';
                                }
                              },
                              onSaved: (value) => namaseries = value!,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Brands : ",
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
                            title: Text('Spring Air',
                                style: TextStyle(fontSize: 14)),
                            value: '4',
                            onChanged: (val) {
                              setState(() {
                                brands = val.toString();
                                getSWData(brands);
                                print(brands);
                              });
                            },
                          ),
                        ),
                        Container(
                          child: RadioListTile(
                            groupValue: brands,
                            title: Text(
                              'Super Fit',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: '2',
                            onChanged: (val) {
                              setState(() {
                                brands = val.toString();
                                getSWData(brands);
                              });
                            },
                          ),
                        ),
                        Container(
                          child: RadioListTile(
                            groupValue: brands,
                            title: Text(
                              'Comforta X',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: '5',
                            onChanged: (val) {
                              setState(() {
                                brands = val.toString();
                                getSWData(brands);
                              });
                            },
                          ),
                        ),
                        Container(
                          child: RadioListTile(
                            groupValue: brands,
                            title: Text(
                              'Comforta',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: '1',
                            onChanged: (val) {
                              setState(() {
                                brands = val.toString();
                                getSWData(brands);
                              });
                            },
                          ),
                        ),
                        Container(
                          child: RadioListTile(
                            groupValue: brands,
                            title: Text(
                              'Theraphedic',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: '3',
                            onChanged: (val) {
                              setState(() {
                                brands = val.toString();
                                getSWData(brands);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Product Type : ",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TypeAheadFormField<User>(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAhead,
                          decoration:
                              InputDecoration(hintText: 'Product Type')),
                      suggestionsCallback: (s) => products.where((c) =>
                          c.name.toLowerCase().contains(s.toLowerCase())),
                      itemBuilder: (ctx, products) => Text(products.name,
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'OpenSans')),
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (products) {
                        _typeAhead.text = products.name;
                        product = products.id.toString();
                        print(product);
                      },
                      validator: (values) {
                        if (values!.isEmpty) {
                          return 'Please select ';
                        }
                      },
                      onSaved: (values) => product = values!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Product Category : ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: category,
                            title: Text(
                              'Matras',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Matras',
                            onChanged: (val) {
                              setState(() {
                                category = val.toString();

                                print(category);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: category,
                            title: Text(
                              'Foundation',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Foundation',
                            onChanged: (val) {
                              setState(() {
                                category = val.toString();
                                print(category);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: category,
                            title: Text(
                              'Headboard',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Headboard',
                            onChanged: (val) {
                              setState(() {
                                category = val.toString();

                                print(category);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: category,
                            title: Text(
                              'Multibed',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Multibed',
                            onChanged: (val) {
                              setState(() {
                                category = val.toString();
                                print(category);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Product Size"),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        width: MediaQuery.of(context).size.width / 1,
                        color: Colors.grey,
                      ),
                      onChanged: (data) {
                        setState(() {
                          dropdownValue = data.toString();
                          print(dropdownValue);
                        });
                      },
                      items: spinnerItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Complaint : ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Amblas',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Amblas',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();

                                print(complaint);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Lembab',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Lembab',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();
                                print(complaint);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Bunyi',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Bunyi',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();

                                print(complaint);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Feel',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Feel',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();
                                print(complaint);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Cacat',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Cacat',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();
                                print(complaint);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Per',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Per',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();
                                print(complaint);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: complaint,
                            title: Text(
                              'Dll',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: 'Dll',
                            onChanged: (val) {
                              setState(() {
                                complaint = val.toString();
                                print(complaint);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    Text(
                      "Notes : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onSaved: (e) => title = e!,
                      controller: formnote,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Catatan Mengenai Keluhan",
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
        ));
  }
}
