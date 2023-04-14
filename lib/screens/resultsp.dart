// import 'package:alitaiosmobile/Screendone/inputpesanan.dart';
// import 'package:alitaiosmobile/print/web.dart';
// import 'package:alitaiosmobile/screens/Detailorder.dart';
// import 'package:alitaiosmobile/spalshcreen.dart';
// import 'package:flutter/material.dart';

// String? no, id;

// class orderdetails {
//   int id;
//   String desc1;
//   String desc2;
//   int unitprice;

//   orderdetails({
//     required this.id,
//     required this.desc1,
//     required this.desc2,
//     required this.unitprice,
//   });
//   factory orderdetails.fromJson(Map<String, dynamic> json) => orderdetails(
//         id: json["id"],
//         desc1: json["desc_1"],
//         desc2: json["desc_2"],
//         unitprice: json["unit_price"],
//       );
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "desc_1": desc1,
//         "desc_2": desc2,
//         "unit_price": unitprice,
//       };
// }

// class resultSP extends StatefulWidget {
//   const resultSP({Key? key}) : super(key: key);

//   @override
//   State<resultSP> createState() => _resultSPState();
// }

// class _resultSPState extends State<resultSP> {
//   List<SPmodel> model = <SPmodel>[];
//   List<alamatmodel> listModel = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(10, 10, 0, 70),
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.arrow_back_ios),
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => Splash()
//                                     // invoice: widget.invoice,
//                                     ));
//                           },
//                         ),
//                         Text(
//                           'Detail Order',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: 'OpenSans',
//                               color: Colors.white),
//                         ),
//                         SizedBox(
//                           width: 150,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           brightness: Brightness.dark,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           toolbarHeight: 150,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               image: const DecorationImage(
//                 image: AssetImage('assets/bginput.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//         ),
//         body: Container(
//             child: Column(children: [
//           Container(
//             height: 0,
//             child: Expanded(
//                 child: ListView.builder(
//               itemCount: model.length,
//               // physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, playerIndex) {
//                 final nDataList = model[playerIndex];
//                 no = model.last.nosp;
//                 id = model.last.id.toString();

//                 return Column();
//               },
//             )),
//           ),
//           Container(
//               width: MediaQuery.of(context).size.width / 1,
//               height: 70,
//               child: Expanded(
//                 child: ListView.builder(
//                   itemCount: listModel.length,
//                   itemBuilder: (context, playerIndex) {
//                     final nDataList = listModel[playerIndex];
//                     return Card(
//                         child: InkWell(
//                       child: Container(
//                           width: MediaQuery.of(context).size.width / 1,
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               // shape: BoxShape.circle,
//                               color: Colors.white,
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black,
//                                 )
//                               ]),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               IconButton(
//                                 padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                                 icon: Icon(
//                                   Icons.location_pin,
//                                   size: 40,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               PdfPreviewPage()));
//                                 },
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Pembeli , ",
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                         ),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 2,
//                                         child: Text(
//                                           listModel.last.cusnama.toString(),
//                                           style: TextStyle(
//                                               fontSize: 9,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                       )
//                                     ],
//                                   ),

//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Alamat , ",
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                         ),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.8,
//                                         child: Text(
//                                           listModel.last.alamat.toString(),
//                                           style: TextStyle(
//                                               fontSize: 9,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   // SizedBox(
//                                   //   height: 5,
//                                   // ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Tanggal Kirim ,",
//                                         style: TextStyle(
//                                           fontSize: 9,
//                                         ),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       Text(
//                                         listModel.last.date.toString(),
//                                         style: TextStyle(
//                                             fontSize: 9,
//                                             fontWeight: FontWeight.bold),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )
//                             ],
//                           )),
//                       onTap: () {
//                         // Navigator.pushReplacement(
//                         //     context,
//                         //     new MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             detailproduk(listModell[index])));
//                       },
//                     ));
//                   },
//                 ),
//               )),
//         ])));
//   }
// }
