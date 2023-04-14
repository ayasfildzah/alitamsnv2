import 'package:alitamsniosmobile/Customerbaru/menucutomerbaru.dart';
import 'package:flutter/material.dart';

class cusindirect3 extends StatefulWidget {
  const cusindirect3({Key? key}) : super(key: key);

  @override
  State<cusindirect3> createState() => _cusindirect3State();
}

class _cusindirect3State extends State<cusindirect3> {
  @override
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
              Text(
                'Customer Indirect',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 60,
        left: 185,
        // width: 250,
        // height: 250,
        child: Container(
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
                      height: 10,
                    ),
                    Text(
                      'Plafon Kredit : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan plafon kredit",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Discount : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan discount",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Termin Pembayaran : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                        onSaved: (e) => title = e!,
                        controller: formnote,
                        decoration: InputDecoration(
                            hintText: "Masukan termin pembayaran",
                            hintStyle: TextStyle(fontSize: 12))),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Metode Pembayaran : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            groupValue: radioitem,
                            title: Text("Cek / Giro"),
                            value: 'Open',
                            onChanged: (val) {
                              setState(() {
                                radioitem = val.toString();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            groupValue: radioitem,
                            title: Text("Transfer"),
                            value: 'Sedang Survey',
                            onChanged: (val) {
                              setState(() {
                                radioitem = val.toString();
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
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
