import 'package:alitamsniosmobile/Customerbaru/cusindirect3.dart';
import 'package:alitamsniosmobile/Customerbaru/menucutomerbaru.dart';
import 'package:flutter/material.dart';

class cusdirect extends StatefulWidget {
  const cusdirect({Key? key}) : super(key: key);

  @override
  State<cusdirect> createState() => _cusdirectState();
}

class _cusdirectState extends State<cusdirect> {
  TextEditingController formnote = TextEditingController();
  String title = '';
  String radioitem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            // padding: EdgeInsets.all(10),
            child: Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 40),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bginput.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => menucustomerbaru()));
                },
              ),
              Container(
                height: 40,
                width: 200,
                child: Text(
                  'Customer Direct, Online Shop dan TV Shop',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
      Positioned(
        top: 70,
        left: 220,
        // width: 250,
        // height: 250,
        child: Container(
            width: 200,
            height: 200,
            // padding: EdgeInsets.fromLTRB(200, 50, 0, 0),
            child: Image.asset(
              'assets/neural.png',
            )),
      ),
      Positioned(
        top: 200,
        left: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No. NPWP : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan no npwp",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No. KTP : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan no ktp",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Nama Bank : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan nama bank",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Nama Rekening : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan nama rekening",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No. Rekening : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan no rekening",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.topRight,
                      child: MaterialButton(
                        elevation: 5.0,
                        child: Text('Simpan',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => menucustomerbaru()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xffff0A387E),
                      ),
                    )
                  ],
                )),
          ),
        ),
      )
    ])));
  }
}
