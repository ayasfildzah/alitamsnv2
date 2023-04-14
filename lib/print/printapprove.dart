import 'dart:convert';
import 'dart:io';
import 'package:alitamsniosmobile/print/pdfresult.dart';
import 'package:alitamsniosmobile/print/testprint.dart';
// import 'package:alitaiosmobile/screens/Detailorder.dart';
import 'package:flutter/services.dart';
// import 'file_handle_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<orderdetails>>? futureData;
List<orderdetails> detail = [];
var filteredList;

class PdfInvoiceAproved {
  static Future<File> generate({
    String? kir,
    String? nosp,
    String? pem,
    String? or,
    String? al,
    double? total,
    String? pesan,
  }) async {
    final pdf = pw.Document();

    final iconImage =
        (await rootBundle.load('assets/mkp.png')).buffer.asUint8List();

    // final tableHeaders = [
    //   'Description',
    //   'Quantity',
    //   'Unit Price',
    //   'VAT',
    //   'Total',
    // ];

    final imageback = pw.MemoryImage(
      (await rootBundle.load(
        'assets/stampapprove.png',
      ))
          .buffer
          .asUint8List(),
    );
    final currencyFormatter = NumberFormat('#,##0', 'ID');

    Future<List<orderdetails>> showdetails() async {
      print("number2 = " + nosp!);
      var jsonResponse = await http
          .get('https://alita.massindo.com/api/v1/order_letter_details');
      if (jsonResponse.statusCode == 200) {
        var data = json.decode(jsonResponse.body);
        var rest = data["result"] as List;
        var filter;
        filter = rest.where((val) => val["no_sp"] == nosp);

        detail = filter
            .map<orderdetails>(
                (parsedJson) => orderdetails.fromJson(parsedJson))
            .toList();
        // print(filteredList);
        return detail;
      } else {
        throw Exception('Failed to load data from internet');
      }
    }

    // final tableData = [
    //   [
    //     'Coffee',
    //     '7',
    //     '\$ 5',
    //     '1 %',
    //     '\$ 35',
    //   ],
    //   [
    //     'Blue Berries',
    //     '5',
    //     '\$ 10',
    //     '2 %',
    //     '\$ 50',
    //   ],
    //   [
    //     'Water',
    //     '1',
    //     '\$ 3',
    //     '1.5 %',
    //     '\$ 3',
    //   ],
    //   [
    //     'Apple',
    //     '6',
    //     '\$ 8',
    //     '2 %',
    //     '\$ 48',
    //   ],
    //   [
    //     'Lunch',
    //     '3',
    //     '\$ 90',
    //     '12 %',
    //     '\$ 270',
    //   ],
    //   [
    //     'Drinks',
    //     '2',
    //     '\$ 15',
    //     '0.5 %',
    //     '\$ 30',
    //   ],
    //   [
    //     'Lemon',
    //     '4',
    //     '\$ 7',
    //     '0.5 %',
    //     '\$ 28',
    //   ],
    // ];

    showdetails();
    futureData = showdetails();
    print(filteredList);
    pdf.addPage(pw.MultiPage(
        // header: (context) {
        //   return pw.Text(
        //     'Flutter Approach',
        //     style: pw.TextStyle(
        //       fontWeight: pw.FontWeight.bold,
        //       fontSize: 15.0,
        //     ),
        //   );
        // },
        build: (context) {
      return [
        pw.Row(
          children: [
            pw.Image(
              pw.MemoryImage(iconImage),
              height: 72,
              width: 72,
            ),
            pw.SizedBox(width: 1 * PdfPageFormat.mm),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'MASSINDO GROUP',
                  style: pw.TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                // pw.Text(
                //   'Flutter Approach',
                //   style: const pw.TextStyle(
                //     fontSize: 15.0,
                //     color: PdfColors.grey700,
                //   ),
                // ),
              ],
            ),
            pw.Spacer(),
            pw.SizedBox(height: 10),
          ],
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(300, 0, 0, 10),
          child: pw.Column(
            children: [
              // Text("No. SP  :" + invoice.customer),
              pw.Text("No. SP               : " + nosp!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
              pw.Text("Tanggal Pesan  : " + or!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
              pw.Text("Tanggal Kirim    : " + kir!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
            ],
            crossAxisAlignment: pw.CrossAxisAlignment.start,
          ),
        ),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        // pw.Divider(),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text("SURAT PESANAN",
              style: pw.TextStyle(fontSize: 14, color: PdfColors.black),
              textAlign: pw.TextAlign.center),
        ),

        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(0, 15, 30, 0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Text("No. SP  :" + invoice.customer),
              pw.Text("Nama Pengirim    : " + " " + pesan!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
              pw.Text("Nama Customer   : " + " " + pem!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
              pw.Text("Alamat                  : " + " " + al!,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
            ],
          ),
        ),
        pw.Container(
          height: 20,
        ),

        pw.SizedBox(height: 5 * PdfPageFormat.mm),

        ///
        /// PDF Table Create
        ///
        //
        pw.Container(
            decoration: pw.BoxDecoration(
              image: pw.DecorationImage(image: imageback, fit: pw.BoxFit.none),
            ),
            child: pw.Table.fromTextArray(
              // headers: tableHeaders,
              data: <List<String>>[
                <String>[
                  'Qty ',
                  'NAMA BARANG',
                  'TYPE/WARNA',
                  'HARGA BRUTO',
                  '%DISC ',
                  'HARGA NETTO'
                ],
                for (int i = 0; i < detail.length; i++)
                  <String>[
                    // '${i + 1}) ${detail.elementAt(i).desc1}',
                    (detail.elementAt(i).qty.toString()),
                    (detail.elementAt(i).desc1),
                    (detail.elementAt(i).desc2),
                    ('Rp. ' + detail.elementAt(i).unitprice.toString()),

                    ' ',
                    ('Rp. ' + detail.elementAt(i).item),
                  ],
              ],
              border: null,
              headerStyle: pw.TextStyle(
                fontSize: 10,
              ),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,

              cellStyle: pw.TextStyle(fontSize: 9),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.center,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.center,
              },
            )),
        pw.Divider(),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Container(
              padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PaddedTextcenter1(
                      "No. PO          : ",
                    ),
                    PaddedTextcenter1("Keterangan   :"),
                  ])),
          pw.Container(
              padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PaddedTextcenter1(
                      "..",
                    ),
                    PaddedTextcenter1(".."),
                  ])),
          pw.Container(
              padding: pw.EdgeInsets.fromLTRB(200, 10, 0, 10),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
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
          pw.Container(
              padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PaddedTextcenter1(
                      'Rp. ' + currencyFormatter.format(total),
                    ),
                    PaddedTextcenter1(".."),
                    // Text(
                    //   "Rp",
                    // ),
                    // Text(".."),
                  ])),

          // pw.Container(
          //   alignment: pw.Alignment.centerRight,
          //   child: pw.Row(
          //     children: [
          //       pw.Spacer(flex: 6),
          //       pw.Expanded(
          //         flex: 4,
          //         child: pw.Column(
          //           crossAxisAlignment: pw.CrossAxisAlignment.start,
          //           children: [
          //             pw.Row(
          //               children: [
          //                 pw.Expanded(
          //                   child: pw.Text(
          //                     'Net total',
          //                     style: pw.TextStyle(
          //                       fontWeight: pw.FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 pw.Text(
          //                   '\$ 464',
          //                   style: pw.TextStyle(
          //                     fontWeight: pw.FontWeight.bold,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             pw.Row(
          //               children: [
          //                 pw.Expanded(
          //                   child: pw.Text(
          //                     'Vat 19.5 %',
          //                     style: pw.TextStyle(
          //                       fontWeight: pw.FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 pw.Text(
          //                   '\$ 90.48',
          //                   style: pw.TextStyle(
          //                     fontWeight: pw.FontWeight.bold,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             pw.Divider(),
          //             pw.Row(
          //               children: [
          //                 pw.Expanded(
          //                   child: pw.Text(
          //                     'Total amount due',
          //                     style: pw.TextStyle(
          //                       fontSize: 14.0,
          //                       fontWeight: pw.FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 pw.Text(
          //                   '\$ 554.48',
          //                   style: pw.TextStyle(
          //                     fontWeight: pw.FontWeight.bold,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             pw.SizedBox(height: 2 * PdfPageFormat.mm),
          //             pw.Container(height: 1, color: PdfColors.grey400),
          //             pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
          //             pw.Container(height: 1, color: PdfColors.grey400),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
          pw.Container(
            padding: pw.EdgeInsets.fromLTRB(235, 10, 0, 0),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PaddedTextcenter1(
                    "Total Belanja ",
                  ),
                  PaddedTextcenter1("Uang Muka"),
                  PaddedTextcenter1("Sisa")
                ]),
          ),
          pw.Container(
              padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PaddedTextcenter1(
                      "Rp. " + currencyFormatter.format(total),
                    ),
                    PaddedTextcenter1(".."),
                    PaddedTextcenter1(".."),
                  ])),
        ]),
        pw.Container(height: 20),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black),
          children: [
            pw.TableRow(
              children: [
                pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Catatan :",
                                style: pw.TextStyle(
                                    fontSize: 10, color: PdfColors.grey900)),
                            pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("1. ",
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.grey900)),
                                    pw.Container(
                                      width: 165,
                                      child: pw.Text(
                                          " Barang yang sudah dibeli tidak dapat ditukar / dikembalikan",
                                          maxLines: 2,
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColors.grey900)),
                                    ),
                                  ]),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("2. ",
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.grey900)),
                                    pw.Container(
                                      width: 165,
                                      child: pw.Text(
                                          "Semua uang muka yang telah dibayar tidak dapat dikembalikan",
                                          maxLines: 2,
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColors.grey900)),
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                    flex: 2),
                pw.Expanded(child: PaddedTextcenter('Mengetahui'), flex: 1),
                pw.Expanded(
                    child: PaddedTextcenter(
                      'Pembeli',
                    ),
                    flex: 1),
                pw.Expanded(
                    child: PaddedTextcenter(
                      'Penjual',
                    ),
                    flex: 1)
              ],
            ),
          ],
        ),
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: pw.Text(
            'Surat Pesanan ini sah dan diproses oleh komputer. Silahkan hubungi Team ACS apabila kamu membutuhkan bantuan.',
            style: pw.Theme.of(context)
                .header5
                .copyWith(fontSize: 10, color: PdfColors.grey),
            textAlign: pw.TextAlign.left,
          ),
        )
      ];
    }));

    return FileHandleApi.saveDocument(
        name: 'invoice' " " + "no sp : " + nosp! + '.pdf', pdf: pdf);
  }
}

pw.Widget PaddedText(
  final String text, {
  final pw.TextAlign align = pw.TextAlign.left,
}) =>
    pw.Padding(
      padding: pw.EdgeInsets.all(10),
      child: pw.Text(text,
          textAlign: align,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.blue900)),
    );
pw.Widget PaddedTextcenter(final String text,
        {final pw.TextAlign align = pw.TextAlign.center}) =>
    pw.Padding(
      padding: pw.EdgeInsets.all(10),
      child: pw.Text(text,
          textAlign: align,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey900)),
    );
pw.Widget PaddedTextcenter1(final String text,
        {final pw.TextAlign align = pw.TextAlign.center}) =>
    pw.Padding(
      padding: pw.EdgeInsets.all(1),
      child: pw.Text(text,
          textAlign: align,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey900)),
    );
