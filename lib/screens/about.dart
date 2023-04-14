import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late SharedPreferences sharedPreferences;
  String KEYStatus = "";

  void initState() {
    // TODO: implement initState
    super.initState();
    // getStringValuesSF();
  }

  // getStringValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     KEYStatus = prefs.getString("status")!;
  //   });

  //   // image.load(showimage);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 50.0,
              // ),
              Image.asset(
                'assets/satu.png',
                // width: 150,
                // height: 100,
              ),
              Text(
                'Massindo Group adalah perusahaan yang bergerak di bedding industry yang sudah berdiri sejak tahun 1983. Brand-brand di bawah naungan Massindo Group sudah terbukti kualitasnya dan dipercaya oleh seluruh masyarakat di Indonesia. Brand- brand tersebut antara lain: Spring Air, Therapedic, Comforta, Super Fit, dan Protect-A-Bed.',
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.black,
                    fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0,
              ),
              Image.asset(
                'assets/dua.png',
                // width: 50,
                // height: 50,
              ),
              Text(
                'Massindo Group telah hadir di 20 kota di seluruh Indonesia, yaitu : Medan, Pekanbaru, Jakarta, Bandung, Semarang, Yogyakarta, Surabaya, Bali, Mataram, Samarinda, Balikpapan, Banjarmasin, Manado, Kotamobagu, Makassar, Kendari, Palu, Gorontalo, Ternate dan Ambon. Tak hanya hadir di Indonesia, Massindo Group kini melebarkan sayapnya dengan membuka gallery dan kantor cabang pertamanya di luar negeri, tepatnya di Singapura.',
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.black,
                    fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0,
              ),
              Image.asset(
                'assets/tiga.png',
                // width: 50,
                // height: 50,
              ),
              Text(
                'Produk-produk Massindo Group juga telah diekspor, diterima dengan baik dan dijual di German, China, Malaysia dan Sri Lanka.',
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.black,
                    fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
