import 'package:alitamsniosmobile/print/cetak.dart';
import 'package:alitamsniosmobile/print/printshow.dart';
import 'package:alitamsniosmobile/print/printapprove.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailPage extends StatelessWidget {
  // final Invoice invoice;
  // const DetailPage({
  //   Key? key,
  //   required this.invoice,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => PdfPreviews(invoice: invoice),
          //   ),
          // );
        },
        child: Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        title: Text("invoice.name"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Customer',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "invoice.customer",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Card(
          //     child: Column(
          //       children: [
          //         Text(
          //           'Invoice Items',
          //           style: Theme.of(context).textTheme.headline6,
          //         ),
          //         ...invoice.items.map(
          //           (e) => ListTile(
          //             title: Text(e.description),
          //             trailing: Text(
          //               e.cost.toStringAsFixed(2),
          //             ),
          //           ),
          //         ),
          //         DefaultTextStyle.merge(
          //           style: Theme.of(context).textTheme.headline4,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               Text("Total"),
          //               Text(
          //                 invoice.totalCost().toStringAsFixed(2),
          //               ),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
