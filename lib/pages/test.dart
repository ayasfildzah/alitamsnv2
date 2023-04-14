import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Results {
  int id;
  String IMDSC1;
  String IMSRP2;

  Results({required this.id, required this.IMDSC1, required this.IMSRP2});

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        IMDSC1: json["IMDSC1"],
        IMSRP2: json["IMSRP2"],
      );
  Map<String, dynamic> toJson() => {
        "IMDSC1": IMDSC1,
        "IMSRP2": IMSRP2,
      };
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  var velocityEditingController = TextEditingController();
  var finalValue = TextEditingController();

  int? airFlow;
  int? velocity;
  int? valueFinal;
  String sam = "";
  String sam2 = "";
  String airFlowText = "";
  String velocityText = "";
  String finalText = "";

  TextEditingController currencyControler = TextEditingController();

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  String totalCalculated() {
    airFlowText = textEditingController.text;
    velocityText = velocityEditingController.text;
    finalText = finalValue.text;

    if (airFlowText != '' && velocityText != '') {
      sam = (airFlow! + velocity!).toString();
      // finalValue.value = finalValue.value.copyWith(
      //   text: sam.toString(),
      // );
    }
    return sam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            // key: Key(totalCalculated()),
            controller: textEditingController,
            onChanged: (textEditingController) {
              setState(() {
                airFlow = int.parse(textEditingController.toString());
              });
            },
            onTap: () {
              setState(() {
                textEditingController.clear();
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter Value',
              labelText: 'Air Flow',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: velocityEditingController,
            onChanged: (velocityEditingController) {
              setState(() {
                velocity = int.parse(velocityEditingController.toString());
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter Value',
              labelText: 'Velocity',
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            key: Key(totalCalculated()),
            controller: finalValue,
            onChanged: (finaValue) {
              setState(() {
                valueFinal = int.parse(finalValue.toString());
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter Value',
              labelText: 'Final Value',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: currencyControler,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (string) {
              string = '${formNum(
                string.replaceAll(',', ''),
              )}';
              currencyControler.value = TextEditingValue(
                text: string,
                selection: TextSelection.collapsed(
                  offset: string.length,
                ),
              );
            },
          ),
          Text('Entered Value is  $sam'),
        ],
      ),
    );
  }
}
