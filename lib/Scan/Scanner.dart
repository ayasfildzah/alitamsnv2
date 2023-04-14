import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => new _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey();
  Barcode? barcode;
  String result = "";
  QRViewController? _controller;

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea),
            onQRViewCreated: (QRViewController controller) {
              this._controller = controller;
              controller.scannedDataStream.listen((value) {
                if (mounted) {
                  _controller!.dispose();
                  Navigator.pop(context, value.code);
                  print(value.code);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
