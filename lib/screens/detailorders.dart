import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alitamsniosmobile/screens/pilihcustomer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? nosp, descrip1, descrip2;
int? price, idmat, idorder;
String? pembeli, alamat, order, kirim, pemesan;

class alamatmodel {
  int id;
  String alamat, pengirim, tlpn;
  double total;
  String cusnama, nosp;
  String date, order;

  alamatmodel({
    required this.id,
    required this.alamat,
    required this.cusnama,
    required this.pengirim,
    required this.tlpn,
    required this.total,
    required this.nosp,
    required this.date,
    required this.order,
  });
  factory alamatmodel.fromJson(Map<String, dynamic> json) => alamatmodel(
        id: json["id"],
        alamat: json["address_ship_to"],
        cusnama: json["ship_to_name"],
        pengirim: json["customer_name"],
        total: json["extended_amount"],
        tlpn: json["phone"],
        date: json["request_date"],
        nosp: json["no_sp"],
        order: json["order_date"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "address": alamat,
        "customer_name": cusnama,
        "request_date": date,
        "no_sp": nosp,
        "order_date": order,
      };
}

class detailorders extends StatefulWidget {
  const detailorders({Key? key}) : super(key: key);

  @override
  State<detailorders> createState() => _detailordersState();
}

class _detailordersState extends State<detailorders> {
  bool loading = false;
  List<alamatmodel> listModel = [];

  Future<void> showSP() async {
    http.Response jsonResponse =
        await http.get('https://alita.massindogroup.com/api/v1/order_letters');
    // print("https://alita.massindo.com/api/v1/image_item_masters?short_item=" +
    //     item);
    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);
      var rest = jsonItems["result"] as List;
      print(rest);
      setState(() {
        for (Map<String, dynamic> i in rest) {
          listModel.add(alamatmodel.fromJson(i));
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
                          removeValues() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            //Remove String
                            prefs.remove("itemnumber");
                            prefs.remove("desc1");
                            prefs.remove("desc2");
                            prefs.remove("desc4");
                            prefs.remove("desc2save");
                            prefs.remove("desc2save2");
                            prefs.remove("itemnumber1");
                            prefs.remove("desc3");
                            prefs.remove("itemnumber2");
                            print("data terhapus");
                          }

                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => detailproduk(
                          //               brands: brand,
                          //               codebrand: '',
                          //               code: '',
                          //               desc: desc,
                          //               nama: '',
                          //               desc2: '',
                          //               // invoice: widget.invoice,
                          //             )));
                        },
                      ),
                      Text(
                        'Detail Order',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 120,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/bginput.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: 1,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, playerIndex) {
                        final nDataList = listModel[playerIndex];
                        idorder = listModel.last.id;
                        pembeli = listModel.last.cusnama.toString();
                        pemesan = listModel.last.pengirim.toString();
                        alamat = listModel.last.alamat.toString();
                        kirim = listModel.last.date.toString();
                        order = listModel.last.order.toString();

                        return Card(
                            child: InkWell(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                    )
                                  ]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    icon: Icon(
                                      Icons.location_pin,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  pilihcustomer()));
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Pengirim , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              listModel.last.pengirim,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Pembeli , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              pembeli!,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Alamat , ",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            child: Text(
                                              alamat!,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            "Tanggal Kirim ,",
                                            style: TextStyle(
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            kirim!,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          onTap: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     new MaterialPageRoute(
                            //         builder: (context) =>
                            //             detailproduk(listModell[index])));
                          },
                        ));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
