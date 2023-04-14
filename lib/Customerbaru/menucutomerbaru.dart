import 'package:alitamsniosmobile/Customerbaru/cusindirect.dart';
import 'package:alitamsniosmobile/Customerbaru/cusmodern.dart';
import 'package:alitamsniosmobile/Customerbaru/customerdirect.dart';
import 'package:alitamsniosmobile/screens/pilihcustomer.dart';
import 'package:flutter/material.dart';

class menucustomerbaru extends StatefulWidget {
  const menucustomerbaru({Key? key}) : super(key: key);

  @override
  State<menucustomerbaru> createState() => _menucustomerbaruState();
}

class _menucustomerbaruState extends State<menucustomerbaru> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          // Background
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bginput.png'),
              fit: BoxFit.fill,
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 80),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pilihcustomer()));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Input Customer Baru',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),

          // color: red800,
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
        ),

        // Required some widget in between to float AppBar
        Container(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Column(children: <Widget>[
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.fromLTRB(200, 80, 0, 0),
                    child: Image.asset(
                      'assets/neural.png',
                    )),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 120,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                                bottom: 10,
                                left: 40,
                                right: 0,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Color(0xffff0A387E),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade900
                                                  .withOpacity(0.5),
                                              offset: Offset(0.3, 0.6),
                                              blurRadius: 10.0)
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    custindirect()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 20, 30, 0),
                                            child: Column(
                                              children: [
                                                // SizedBox(
                                                //   height: 20,
                                                // ),
                                                Text(
                                                  'Indirect',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Nunito',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                            Positioned(
                              top: 30,
                              left: 0,
                              right: 180,
                              child: Center(
                                child: Container(
                                    child: Image.asset(
                                  'assets/shops.png',
                                  width: 85,
                                  height: 90,
                                  // alignment:
                                  //     Alignment.center,
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 120,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                                bottom: 10,
                                left: 40,
                                right: 0,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Color(0xffff0A387E),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade900
                                                  .withOpacity(0.5),
                                              offset: Offset(0.3, 0.6),
                                              blurRadius: 10.0)
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    customerdirect()));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                50, 10, 0, 0),
                                            child: Column(
                                              children: [
                                                // SizedBox(
                                                //   height: 20,
                                                // ),
                                                Container(
                                                  height: 40,
                                                  width: 160,
                                                  child: Text(
                                                    'Direct,Online Shop & TV Shop',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Nunito',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                            Positioned(
                              top: 30,
                              left: 0,
                              right: 180,
                              child: Center(
                                child: Container(
                                    child: Image.asset(
                                  'assets/buyyer.png',
                                  width: 85,
                                  height: 90,
                                  // alignment:
                                  //     Alignment.center,
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 120,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                                bottom: 10,
                                left: 40,
                                right: 0,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Color(0xffff0A387E),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade900
                                                  .withOpacity(0.5),
                                              offset: Offset(0.3, 0.6),
                                              blurRadius: 10.0)
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    cusmodern()));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                50, 15, 0, 0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 40,
                                                  child: Text(
                                                    'Modern Market & Hospitality',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Nunito',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                            Positioned(
                              top: 30,
                              left: 0,
                              right: 180,
                              child: Center(
                                child: Container(
                                    child: Image.asset(
                                  'assets/shops.png',
                                  width: 85,
                                  height: 90,
                                  // alignment:
                                  //     Alignment.center,
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 50, 200, 0),
                    child: Image.asset(
                      'assets/neural.png',
                      fit: BoxFit.fill,
                    )),
              ),
            ])),
      ],
    ));
  }
}
