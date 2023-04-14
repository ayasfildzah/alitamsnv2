import 'package:alitamsniosmobile/Customerbaru/cusindirect2.dart';
import 'package:alitamsniosmobile/Customerbaru/menucutomerbaru.dart';
import 'package:flutter/material.dart';

class custindirect extends StatefulWidget {
  const custindirect({Key? key}) : super(key: key);

  @override
  State<custindirect> createState() => _custindirectState();
}

class _custindirectState extends State<custindirect> {
  TextEditingController formnote = TextEditingController();
  String title = '';
  String radioitem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // padding: EdgeInsets.all(10),
          child: Stack(
        children: <Widget>[
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Text(
                          'Brand : ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              groupValue: radioitem,
                              title: Image.asset(
                                'assets/springa.png',
                              ),
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
                              title: Image.asset(
                                'assets/comfort.png',
                              ),
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
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              groupValue: radioitem,
                              title: Image.asset(
                                'assets/therao.png',
                              ),
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
                              title: Image.asset(
                                'assets/super.png',
                              ),
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
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Text(
                          'Type : ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              groupValue: radioitem,
                              title: Text("Deposit Order"),
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
                              title: Text("Regular"),
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
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Toko : ',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              TextFormField(
                                  onSaved: (e) => title = e!,
                                  controller: formnote,
                                  decoration: InputDecoration(
                                      hintText: "Masukan nama toko",
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
                                'No Hp : ',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 0,
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
                              Container(
                                height: 40,
                                alignment: Alignment.topRight,
                                child: MaterialButton(
                                  elevation: 5.0,
                                  child: Text('Selanjutnya',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                cusindirect2()));
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Color(0xffff0A387E),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                )),
              ))
        ],
      )),
    );
  }
}
