import 'package:alitamsniosmobile/Customerbaru/cusdirect.dart';
import 'package:alitamsniosmobile/Customerbaru/cusindirect3.dart';
import 'package:alitamsniosmobile/Customerbaru/cusmodern2.dart';
import 'package:alitamsniosmobile/Customerbaru/menucutomerbaru.dart';
import 'package:flutter/material.dart';

class cusmodern extends StatefulWidget {
  const cusmodern({Key? key}) : super(key: key);

  @override
  State<cusmodern> createState() => _cusmodernState();
}

class _cusmodernState extends State<cusmodern> {
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
                width: 300,
                child: Text(
                  'Customer Modern Market Dan Hospitality',
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
        top: 80,
        left: 220,
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
                      'Nama Perusahaan : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan nama perusahaan",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Nama Pemilik : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan nama pemilik",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No. HP : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan no hp",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan email",
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
                      'Alamat Pemilik : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan alamat pemilik",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.topRight,
                      child: MaterialButton(
                        elevation: 5.0,
                        child: Text('Selanjutnya',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => cusmodern2()));
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
