import 'dart:convert';
import 'dart:typed_data';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

import 'package:alitamsniosmobile/screens/Detailorder.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

List<orderdetails> details = [];

Future<Uint8List> makePdf(
//   {
//   String? al,
//   String? pem,
//   String? or,
//   String? kir,
//   String? nosp,
//   String? desc1,
//   String? desc2,
//   int? prc,
// }
    ) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
    (await rootBundle.load(
      'assets/mkp.png',
    ))
        .buffer
        .asUint8List(),
  );
  @override
  void initState() {
    showdetails();
  }

  final imageback = MemoryImage(
    (await rootBundle.load(
      'assets/pending.png',
    ))
        .buffer
        .asUint8List(),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: Image(imageLogo, width: 50, height: 50),
                ),
                SizedBox(width: 10),
                Text("Massindo Group",
                    style: TextStyle(fontSize: 16, color: PdfColors.grey900)),
                // SizedBox(width: 150),
              ],
            ),

            Container(
              padding: EdgeInsets.fromLTRB(330, 0, 0, 10),
              child: Column(
                children: [
                  // Text("No. SP  :" + invoice.customer),
                  Text("No. SP               : " + "nosp!",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                  Text("Tanggal Pesan  : " + "or!",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                  Text("Tanggal Kirim    : " + "kir!",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: Text("SURAT PESANAN",
                  style: TextStyle(fontSize: 14, color: PdfColors.black),
                  textAlign: TextAlign.center),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("No. SP  :" + invoice.customer),
                  Text("Nama Customer   : " + " " + "pem!",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                  Text("Nama Customer   : " + " " + "pem",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                  Text("Alamat                  : " + " " + "al!",
                      style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageback, fit: BoxFit.none),
              ),
              child: Table(
                // border: TableBorder.all(color: PdfColors.black),
                // border: TableBorder.symmetric(),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        child: Text(
                          'QTY',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      ),
                      Padding(
                        child: Text(
                          'NAMA BARANG',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                      ),
                      Padding(
                        child: Text(
                          'TYPE/WARNA',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                      ),
                      Padding(
                        child: Text(
                          'HARGA BRUTO',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                      ),
                      Padding(
                        child: Text(
                          '%DISC',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                      ),
                      Padding(
                        child: Text(
                          'HARGA NETTO',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                      ),
                    ],
                  ),

                  // ...invoice.items.map(
                  //   (e) =>

                  TableRow(
                    children: [
                      Expanded(
                        // child: PaddedText(e.description),
                        child: PaddedTextcenter(
                          '1',
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        // child: PaddedText("\$${e.cost}"),
                        child: PaddedText("desc1!"),
                        flex: 2,
                      ),
                      Expanded(
                        // child: PaddedText(e.description),
                        child: PaddedText(
                          "desc2!",
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        // child: PaddedText(e.description),
                        child: PaddedTextcenter(
                          "prc.toString()",
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        // child: PaddedText(e.description),
                        child: PaddedTextcenter(
                          ' ',
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        // child: PaddedText(e.description),
                        child: PaddedTextcenter(
                          "prc.toString()",
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                  // TableRow(children: [
                  //   Expanded(
                  //       child: ListView.builder(
                  //     itemCount: 3,
                  //     itemBuilder: (context, playerIndex) {
                  //       final nDataList = details[playerIndex];
                  //       nosp = nDataList.no_sp;
                  //       descrip1 = nDataList.desc1;
                  //       descrip2 = nDataList.desc2;
                  //       price = nDataList.unitprice;
                  //       // ignore: avoid_print
                  //       print("desk = " +
                  //           descrip1! +
                  //           " " +
                  //           descrip2! +
                  //           " " +
                  //           price!.toString());

                  //       return Column();
                  //     },
                  //   ))
                  // ])

                  // TableRow(
                  //   children: [
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         '1',
                  //       ),
                  //       flex: 1,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText("\$${e.cost}"),
                  //       child: PaddedText("FD. STAR 160"),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedText(
                  //         'BLACK',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         'Rp. 825.000',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         '40+10+5+5',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         'Rp.750.000',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //   ],
                  // ),
                  // TableRow(
                  //   children: [
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         '1',
                  //       ),
                  //       flex: 1,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText("\$${e.cost}"),
                  //       child: PaddedText("HB. BINTANG 160"),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedText(
                  //         'BROWN',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         'Rp. 825.000',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         '40+10+5+5',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //     Expanded(
                  //       // child: PaddedText(e.description),
                  //       child: PaddedTextcenter(
                  //         'Rp. 750.000',
                  //       ),
                  //       flex: 2,
                  //     ),
                  //   ],
                  // ),
                  // TableRow(
                  //   children: [
                  //     PaddedText('TAX', align: TextAlign.right),
                  //     PaddedText(
                  //         '\$${(invoice.totalCost() * 0.1).toStringAsFixed(2)}'),
                  //   ],
                  // ),
                  // TableRow(
                  //   children: [
                  //     PaddedText('TOTAL', align: TextAlign.right),
                  //     PaddedText(
                  //         '\$${(invoice.totalCost() * 1.1).toStringAsFixed(2)}')
                  //   ],
                  // )
                ],
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddedTextcenter1(
                          "No. PO          : ",
                        ),
                        PaddedTextcenter1("Keterangan   :"),
                      ])),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddedTextcenter1(
                          "..",
                        ),
                        PaddedTextcenter1(".."),
                      ])),
              Container(
                  padding: EdgeInsets.fromLTRB(220, 10, 0, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddedTextcenter1(
                          "Total Barang ",
                        ),
                        PaddedTextcenter1("PPN"),

                        // Text(
                        //   "Total Belanja ",
                        // ),
                        // Text("Uang Muka"),
                        // Text("Sisa")
                      ])),
              Container(
                  padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddedTextcenter1(
                          "Rp",
                        ),
                        PaddedTextcenter1(".."),
                        // Text(
                        //   "Rp",
                        // ),
                        // Text(".."),
                      ])),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                width: 200,
              ),
              Container(
                width: 200,
                child: Divider(
                  height: 1,
                  borderStyle: BorderStyle.dashed,
                ),
              ),
            ]),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                padding: EdgeInsets.fromLTRB(245, 10, 0, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaddedTextcenter1(
                        "Total Belanja ",
                      ),
                      PaddedTextcenter1("Uang Muka"),
                      PaddedTextcenter1("Sisa")
                    ]),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddedTextcenter1(
                          "Rp",
                        ),
                        PaddedTextcenter1(".."),
                        PaddedTextcenter1(".."),
                      ])),
            ]),

            // Padding(
            //   padding: EdgeInsets.all(2),
            //   child: Image(imageback, width: 200, height: 200),
            // ),

            Container(height: 20),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan :",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey900)),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("1. ",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: PdfColors.grey900)),
                                        Container(
                                          width: 165,
                                          child: Text(
                                              " Barang yang sudah dibeli tidak dapat ditukar / dikembalikan",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: PdfColors.grey900)),
                                        ),
                                      ]),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("2. ",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: PdfColors.grey900)),
                                        Container(
                                          width: 165,
                                          child: Text(
                                              "Semua uang muka yang telah dibayar tidak dapat dikembalikan",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: PdfColors.grey900)),
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                        flex: 2),
                    Expanded(child: PaddedTextcenter('Mengetahui'), flex: 1),
                    Expanded(
                        child: PaddedTextcenter(
                          'Pembeli',
                        ),
                        flex: 1),
                    Expanded(
                        child: PaddedTextcenter(
                          'Penjual',
                        ),
                        flex: 1)
                  ],
                ),
                // TableRow(
                //   children: [
                //     PaddedText(
                //       'Account Name',
                //     ),
                //     PaddedText(
                //       'ADAM FAMILY TRUST',
                //     )
                //   ],
                // ),
                // TableRow(
                //   children: [
                //     PaddedText(
                //       'Total Amount to be Paid',
                //     ),
                //     PaddedText(
                //         '\$${(invoice.totalCost() * 1.1).toStringAsFixed(2)}')
                //   ],
                // )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                'Surat Pesanan ini sah dan diproses oleh komputer. Silahkan hubungi Team ACS apabila kamu membutuhkan bantuan.',
                style: Theme.of(context)
                    .header5
                    .copyWith(fontSize: 10, color: PdfColors.grey),
                textAlign: TextAlign.left,
              ),
            )
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Future<List<orderdetails>> showdetails() async {
  print("number2 = " + nosp!);
  var jsonResponse = await http
      .get('https://alita.massindogroup.com/api/v1/order_letter_details');
  if (jsonResponse.statusCode == 200) {
    var data = json.decode(jsonResponse.body);
    var rest = data["result"] as List;
    var filteredList;
    filteredList = rest.where((val) => val["no_sp"] == nosp!);

    details = filteredList
        .map<orderdetails>((parsedJson) => orderdetails.fromJson(parsedJson))
        .toList();

    return details;
  } else {
    throw Exception('Failed to load data from internet');
  }
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 10, color: PdfColors.blue900)),
    );
Widget PaddedTextcenter(final String text,
        {final TextAlign align = TextAlign.center}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
    );
Widget PaddedTextcenter1(final String text,
        {final TextAlign align = TextAlign.center}) =>
    Padding(
      padding: EdgeInsets.all(1),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 10, color: PdfColors.grey900)),
    );
