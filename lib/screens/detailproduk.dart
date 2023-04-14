import 'dart:convert';

import 'package:alitamsniosmobile/Screendone/inputpesanan.dart';
import 'package:alitamsniosmobile/print/cetak.dart';
import 'package:alitamsniosmobile/screens/Detailorder.dart';
import 'package:alitamsniosmobile/screens/detailorders.dart';
import 'package:badges/badges.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var buttonsRowDirection = 1; //ROW DIRECTION
var buttonsColDirection = 2;

class detailproduk extends StatefulWidget {
  // const detailproduk({Key? key}) : super(key: key);
  // final listmodell;
  // // detailproduk(highmodel listModell, this.listmodell);
  // const detailproduk(this.listmodell);
  final String code;
  final String desc;
  final String brands;
  final String nama;
  final String codebrand;
  final String desc2;
  // final Invoice invoice;

  const detailproduk({
    Key? key,
    required this.code,
    required this.desc,
    // required this.invoice,
    required this.nama,
    required this.brands,
    required this.codebrand,
    required this.desc2,
  }) : super(key: key);

  @override
  State<detailproduk> createState() => _detailprodukState();
}

class _detailprodukState extends State<detailproduk> {
  List<Results> listModel = [];
  List<highmodel> listModell = [];
  List<Results> _selectedPlayers = [];
  bool loading = false;
  bool isChecked = false;
  bool _visible = false;
  String no = '';
  String id = '';
  int _value = 0;
  String itemnum = "";
  String nmadesc = "";
  String itemnum1 = "";
  String nmadesc1 = "";
  String brandsave = "";
  String desc2save = "";
  String brandsave2 = "";
  int _count = 0;
  String desc2save2 = "";
  String item = "";
  String desc = "";
  String desc2 = "";
  String brand = "";
  String nmabrnd = "";
  List<SPmodel> model = <SPmodel>[];

  void _incrementCounter2() {
    setState(() {
      _count++;

      print("qty = " + _count.toString());
    });
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    item = prefs.getString('itemnumber')!;
    desc = prefs.getString('desc1')!;
    desc2 = prefs.getString('desc2')!;
    brand = prefs.getString('brand')!;
    nmabrnd = prefs.getString('nmabrand')!;
    print("number =" + nmabrnd);
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("itemnumber");
    prefs.remove("desc1");
    prefs.remove("desc2");
    prefs.remove("desc4");
    prefs.remove("desc3");
    prefs.remove("itemnumber1");
    prefs.remove("itemnumber2");
    print("data terhapus");
  }

  showdivan(String itemnum, String nmadesc, String brandsave,
      String desc2save) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('itemnumber1', itemnum);
    prefs.setString('desc4', nmadesc);
    prefs.setString('brandsave', brandsave);
    prefs.setString('desc2save', desc2save);
  }

  showsandaran(String itemnum1, String nmadesc1, String desc2save2,
      String brandsave2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('itemnumber2', itemnum1);
    prefs.setString('desc3', nmadesc1);
    prefs.setString('brandsave2', brandsave2);
    prefs.setString('desc2save2', desc2save2);
  }

  Future<void> showSP() async {
    http.Response jsonResponse =
        await http.get('https://alita.massindo.com/api/v1/order_letters');
    // print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
    //     item);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          model.add(SPmodel.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

  Future<void> showfoto() async {
    setState(() {
      loading = true;
    });
    http.Response jsonResponse =
        await http.get("https://alita.massindo.com/api/v1/item_masters");
    // print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
    //     widget.code);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print("hasil = " + rest.toString());
      setState(() {
        for (Map<String, dynamic> i in rest) {
          listModel.add(Results.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

  Future<void> show() async {
    setState(() {
      loading = true;
    });
    http.Response jsonResponse = await http.get(
        "https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
            widget.code);
    print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
        widget.code);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          listModell.add(highmodel.fromJson(i));
        }
        loading = false;
      });
    } else {
      print("data tidak ada");
    }
  }

  @override
  void initState() {
    super.initState();
    showSP();
    showfoto();
    show();
    getStringValuesSF();
    print("code =" + itemnum1);
  }

  _selectPlayer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Container(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close, color: Colors.white),
                    backgroundColor: Color(0xffff54709E),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Pilih Divan",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter alertState) {
                      return Container(
                        width: 350.0,
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: listModel.length,
                          itemBuilder: (context, playerIndex) {
                            final nDataList = listModel[playerIndex];
                            if (nDataList.imglpt == widget.codebrand &&
                                nDataList.IMSRP2 == "2") {
                              return
                                  // Container(
                                  //     // height: 60,
                                  //     // width: double.infinity,
                                  //     // decoration: BoxDecoration(
                                  //     //   color: Colors.white,
                                  //     //   borderRadius: BorderRadius.circular(5),
                                  //     //   border: Border.all(
                                  //     //       color: Color(0xff263238), width: 0.1),
                                  //     // ),
                                  //     child: Padding(
                                  //   padding: EdgeInsets.only(
                                  //       top: 2, right: 10, left: 10, bottom: 0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Icon(
                                  //         Icons.bedroom_child,
                                  //         color: Color(0xffff54709E),
                                  //         size: 40,
                                  //       ),
                                  //       Container(
                                  //         width: MediaQuery.of(context).size.width /
                                  //             3.5,
                                  //         child: Text(listModel[playerIndex].IMDSC1,
                                  //             style: TextStyle(
                                  //                 fontFamily: 'OpenSans',
                                  //                 fontSize: 12)),
                                  //       ),
                                  //       Radio(
                                  //         value: _selectedPlayers
                                  //             .contains(listModel[playerIndex]),
                                  //         groupValue: _selectedPlayers,
                                  //         activeColor: Colors.orangeAccent,
                                  //         onChanged: (value) {
                                  //           if (_selectedPlayers
                                  //               .contains(listModel[playerIndex])) {
                                  //             _selectedPlayers
                                  //                 .remove(listModel[playerIndex]);
                                  //           } else {
                                  //             _selectedPlayers
                                  //                 .add(listModel[playerIndex]);
                                  //           }
                                  //           setState(() {
                                  //             // _value = value as int;
                                  //           });
                                  //         },
                                  //       )
                                  //     ],
                                  //   ),
                                  // ));

                                  CheckboxListTile(
                                      title: Text(listModel[playerIndex].IMDSC1,
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 12)),
                                      subtitle:
                                          listModel[playerIndex].imdsc2 == null
                                              ? Text(
                                                  " ",
                                                )
                                              : Text(
                                                  listModel[playerIndex]
                                                      .imdsc2
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12)),
                                      value: _selectedPlayers
                                          .contains(listModel[playerIndex]),
                                      onChanged: (bool? value) {
                                        if (_selectedPlayers
                                            .contains(listModel[playerIndex])) {
                                          _selectedPlayers
                                              .remove(listModel[playerIndex]);
                                          removeValues();
                                        } else {
                                          _selectedPlayers
                                              .add(listModel[playerIndex]);
                                        }
                                        setState(() {});
                                        alertState(() {
                                          itemnum =
                                              listModel[playerIndex].imlitm;
                                          nmadesc =
                                              listModel[playerIndex].IMDSC1;
                                          brandsave =
                                              listModel[playerIndex].imglpt;
                                          desc2save =
                                              listModel[playerIndex].imdsc2;
                                          showdivan(itemnum, nmadesc, brandsave,
                                              desc2save);
                                          print("Data yang di pilih : " +
                                              listModel[playerIndex].IMDSC1);
                                        });
                                      },
                                      secondary: Icon(
                                        Icons.bedroom_child,
                                        color: Color(0xffff54709E),
                                        size: 45,
                                      )
                                      //  nDataList.img.url == null
                                      //     ? const Icon(
                                      //         Icons.bedroom_child,
                                      //         color: Color(0xffff54709E),
                                      //         size: 45,
                                      //       )
                                      //     : Image.network(
                                      //         nDataList.img.url,
                                      //         fit: BoxFit.contain,
                                      //         width: 40,
                                      //       ),
                                      );
                            } else
                              return Container();
                            {}
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Pilih Sandaran",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter alertState) {
                      return Container(
                        width: 350.0,
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: listModel.length,
                          itemBuilder: (context, playerIndex) {
                            final nDataList = listModel[playerIndex];
                            if (nDataList.imglpt == widget.codebrand &&
                                nDataList.IMSRP2 == "3") {
                              return CheckboxListTile(
                                  title: Text(listModel[playerIndex].IMDSC1,
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 12)),
                                  subtitle:
                                      listModel[playerIndex].imdsc2 == null
                                          ? Text(
                                              " ",
                                            )
                                          : Text(
                                              listModel[playerIndex]
                                                  .imdsc2
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12)),
                                  value: _selectedPlayers
                                      .contains(listModel[playerIndex]),
                                  onChanged: (bool? value) {
                                    if (_selectedPlayers
                                        .contains(listModel[playerIndex])) {
                                      _selectedPlayers
                                          .remove(listModel[playerIndex]);
                                    } else {
                                      _selectedPlayers
                                          .add(listModel[playerIndex]);
                                    }
                                    setState(
                                        () {}); //ALSO UPDATE THE PARENT STATE
                                    alertState(() {
                                      itemnum1 = listModel[playerIndex].imlitm;
                                      nmadesc1 = listModel[playerIndex].IMDSC1;
                                      brandsave2 =
                                          listModel[playerIndex].imglpt;
                                      desc2save2 =
                                          listModel[playerIndex].imdsc2;
                                      showsandaran(itemnum1, nmadesc1,
                                          desc2save2, brandsave2);
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.bedroom_child,
                                    color: Color(0xffff54709E),
                                    size: 45,
                                  )
                                  //  nDataList.img.url == null
                                  //     ? const Icon(
                                  //         Icons.bedroom_child,
                                  //         color: Color(0xffff54709E),
                                  //         size: 45,
                                  //       )
                                  //     : Image.network(
                                  //         nDataList.img.url,
                                  //         fit: BoxFit.contain,
                                  //         width: 40,
                                  //       ),
                                  );
                            } else
                              return Container();
                            {}
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MaterialButton(
                      minWidth: 150,
                      //height: 40,
                      elevation: 5.0,
                      child: Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xffff0A367E),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
      },
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    print('oldIndex:$oldIndex');
    print('newIndex:$newIndex');
    setState(() {
      Results player = listModel[newIndex];
      _selectedPlayers[newIndex] = _selectedPlayers[oldIndex];
      _selectedPlayers[oldIndex] = player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 70),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            removeValues();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inputpesan(
                                        // invoice: widget.invoice,
                                        // pemilik: toString(),
                                        // alamat: toString(),
                                        // tgl: toString(),
                                        )));
                          },
                        ),
                        Text(
                          'Detail Produk',
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'OpenSans',
                              color: Colors.white),
                        ),
                        // SizedBox(
                        //   width: 80,
                        // ),

                        // IconButton(
                        //   icon: Icon(
                        //     Icons.shopping_cart,
                        //     size: 30,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {
                        //     Navigator.pushReplacement(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => Detailorder()));
                        //   },
                        // ),
                        // Positioned(
                        //   right: 10.0,
                        //   top: 0.0,
                        //   bottom: 30,
                        //   //width: 30,
                        //   child: InkResponse(
                        //     onTap: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: CircleAvatar(
                        //       child: Text("1",
                        //           style: TextStyle(
                        //               color: Colors.white, //badge font color
                        //               fontSize: 14 //badge font size
                        //               )),
                        //       backgroundColor: Colors.red,
                        //     ),
                        //   ),
                        // ),

                        // Badge(
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.shopping_cart,
                        //       size: 30,
                        //       color: Colors.white,
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => Detailorder(
                        //                   // invoice: widget.invoice,
                        //                   // pemilik: toString(),
                        //                   // alamat: toString(),
                        //                   // tgl: toString(),
                        //                   )));
                        //     },
                        //   ),

                        //   //icon style
                        //   badgeContent: SizedBox(
                        //       width: 16,
                        //       height: 16, //badge size
                        //       child: Center(
                        //         //aligh badge content to center
                        //         child: Text("1",
                        //             style: TextStyle(
                        //                 color: Colors.white, //badge font color
                        //                 fontSize: 16 //badge font size
                        //                 )),
                        //       )),
                        //   badgeColor: Colors.red, //badge background color
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0, top: 5, bottom: 60),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(15),
                // ),
                height: 20,
                width: 45,
                child: IconButton(
                  icon: Stack(children: <Widget>[
                    new Icon(
                      Icons.shopping_cart,
                      size: 40,
                      color: Colors.white,
                    ),
                    new Positioned(
                        // draw a red marble
                        top: 0.0,
                        right: 0.0,
                        left: 10,
                        child: Visibility(
                          visible: _visible,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Color(0xFFFF4545),
                            ),
                            child: Text(_count.toString(),
                                textAlign: TextAlign.center),
                          ),
                        ))
                  ]),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 150,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bginput.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: listModell.isEmpty
                      ? ListView.builder(
                          itemCount: listModell.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, playerIndex) {
                            final nDataList = listModell[playerIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    // ignore: unnecessary_null_comparison
                                    child: nDataList.img.url.isEmpty
                                        ? const Icon(
                                            Icons.bed,
                                            color: Colors.lightBlue,
                                            size: 165,
                                          )
                                        : Image.network(
                                            nDataList.img.url,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                Text(
                                  nDataList.desc,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            );
                          },
                        )
                      : Image.asset(
                          'assets/kasur.png',
                          width: 150.0,
                          height: 150.0,
                        )),
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: unnecessary_null_comparison
                    widget.desc2 == null
                        ? Text(
                            "${widget.desc}" + " ",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )
                        : Text(
                            "${widget.desc}" + " " + "${widget.desc2}",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                    Text(
                      "${widget.nama}",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                    child: MaterialButton(
                      elevation: 5.0,
                      child: Text(
                        '+ Divan/ Sandaran/ Aksesoris',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      onPressed: () {
                        _selectPlayer();
                        // showGeneralDialog(
                        //     context: context,
                        //     pageBuilder: (BuildContext buildContext,
                        //         Animation animation,
                        //         Animation secondaryAnimation) {
                        //       return _buildDialog(context);
                        //     });
                        // showfoto();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xffff0A367E),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.fromLTRB(100, 0, 0, 20),
                    child: FavoriteButton(
                      isFavorite: false,
                      // iconDisabledColor: Colors.white,
                      valueChanged: (_isFavorite) {
                        print('Is Favorite : $_isFavorite');
                      },
                    ),
                  ),
                ],
              ),
              // Text(
              //   nmadesc,
              //   style: TextStyle(color: Colors.white, fontSize: 10),
              // ),
              Expanded(
                  child: ListView.builder(
                itemCount: model.length,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, playerIndex) {
                  final nDataList = model[playerIndex];
                  no = model.last.nosp;
                  id = model.last.id.toString();

                  return Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                      //   Text(
                      //     "No SP :" + model.last.nosp,
                      //     style: TextStyle(color: Colors.black, fontSize: 18),
                      //   ),
                      // ],
                      );
                },
              )),
              // Flexible(
              //     child: ReorderableListView(
              //   onReorder: _onReorder,
              //   children: _selectedPlayers.map((player) {
              //     return ListTile(
              //       key: ValueKey(player.id),
              //       title: Text(player.IMDSC1 + " " + player.imglpt),
              //       leading: Text("#${_selectedPlayers.indexOf(player) + 1}"),
              //     );
              //   }).toList(),
              // )),
              Expanded(
                child: Container(
                    // alignment: Alignment.center,
                    // color: Colors.red,
                    // child: Text(
                    //   'Anything want in the middle',
                    //   textAlign: TextAlign.center,
                    // ),
                    ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: double.infinity,
                  // color: Colors.white,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(0.2, 0.5),
                        blurRadius: 10.0)
                  ]),
                  child: MaterialButton(
                    minWidth: 300,
                    height: 40,
                    elevation: 5.0,
                    child: Text(
                      '+ Keranjang',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detailorder(
                                  // invoice: widget.invoice,
                                  // pemilik: toString(),
                                  // alamat: toString(),
                                  tipebrand: widget.nama)));
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Color(0xffff0A367E),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//void setState(Null Function() param0) {}

ShapeBorder _defaultShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    side: BorderSide(
      color: Color(0xffff0A367E),
    ),
  );
}

_getCloseButton(context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        alignment: FractionalOffset.topRight,
        child: GestureDetector(
          child: Icon(
            Icons.clear,
            color: Color(0xffff0A367E),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

_getRowButtons(context) {
  return [
    MaterialButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
      color: Color.fromRGBO(0, 179, 134, 1.0),
    ),
    MaterialButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
      color: Color.fromRGBO(0, 179, 134, 1.0),
    )
  ];
}

_getColButtons(context) {
  return [
    MaterialButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
      color: Color.fromRGBO(0, 179, 134, 1.0),
    ),
    MaterialButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
      color: Color.fromRGBO(0, 179, 134, 1.0),
    )
  ];
}
