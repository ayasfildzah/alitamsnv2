import 'package:alitamsniosmobile/fragment.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  // String payload;
  // NewScreen({
  //   required this.payload,
  // });
  final String payload;

  const NewScreen({Key? key, required this.payload}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/mkp.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("MASSINDO GROUP"),
                SizedBox(
                  width: 70,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SURAT PESANAN",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(payload,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
