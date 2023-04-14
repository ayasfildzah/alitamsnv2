import 'dart:convert';
import 'dart:io';
import 'package:alitamsniosmobile/Avaibility/searchallavailibility.dart';
import 'package:alitamsniosmobile/print/pdfresult.dart';
import 'package:alitamsniosmobile/print/testprint.dart';
// import 'package:alitaiosmobile/screens/Detailorder.dart';
import 'package:flutter/services.dart';
// import 'file_handle_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<Results>>? futureData;
List<Results> detail = [];
var filteredList;

class PdfHighApi {
  static Future<File> generate(
      {String? branches, String? brand, String? nmaloc}) async {
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
        'assets/pending.png',
      ))
          .buffer
          .asUint8List(),
    );
    final currencyFormatter = NumberFormat('#,##0', 'ID');

    Future<List<Results>> showdetails() async {
      // print("number2 = " + nosp!);
      var jsonResponse = await http.get(
          'https://alita.massindo.com/api/v1/availability_by_location?branch=$branches&brand_code=$brand');
      if (jsonResponse.statusCode == 200) {
        var data = json.decode(jsonResponse.body);
        var rest = data["result"]["results"] as List;
        // var filter;
        // filter = rest.where((val) => val["no_sp"] == nosp);

        detail = rest
            .map<Results>((parsedJson) => Results.fromJson(parsedJson))
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
              height: 50,
              width: 50,
            ),
            pw.SizedBox(width: 1 * PdfPageFormat.mm),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'MASSINDO GROUP',
                  style: pw.TextStyle(
                    fontSize: 14.0,
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
        // pw.Container(
        //   padding: pw.EdgeInsets.fromLTRB(300, 0, 0, 10),
        //   child: pw.Column(
        //     children: [
        //       // Text("No. SP  :" + invoice.customer),
        //       pw.Text("No. SP               : " + nosp!,
        //           style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
        //       pw.Text("Tanggal Pesan  : " + or!,
        //           style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
        //       pw.Text("Tanggal Kirim    : " + kir!,
        //           style: pw.TextStyle(fontSize: 12, color: PdfColors.grey900)),
        //     ],
        //     crossAxisAlignment: pw.CrossAxisAlignment.start,
        //   ),
        // ),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        // pw.Divider(),
        pw.SizedBox(height: 10 * PdfPageFormat.mm),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(nmaloc!,
              style: pw.TextStyle(fontSize: 14, color: PdfColors.black),
              textAlign: pw.TextAlign.center),
        ),

        pw.Container(
            padding: pw.EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: pw.Table.fromTextArray(
              // headers: tableHeaders,
              data: <List<String>>[
                <String>[
                  'No ',
                  'Brand',
                  'Description',
                  'Qty',
                ],
                for (int i = 0; i < detail.length; i++)
                  <String>[
                    '${i + 1})',
                    ('Comforta'),
                    (detail.elementAt(i).imdsc1 + detail.elementAt(i).imdsc2),
                    ('${detail.elementAt(i).qav ~/ 100}'),
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
              },
            )),
        pw.Divider(),
        PaddedTextcenter1(
          'Total ' + detail.length.toString(),
        ),
      ];
    }));

    return FileHandleApi.saveDocument(
        name: 'high availibility' " " + '.pdf', pdf: pdf);
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
