import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  @override
  _QRGenerator createState() => _QRGenerator();
}

class _QRGenerator extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    final String qrScan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
          child: Center(
        child: QrImage(
          data: qrScan,
          version: QrVersions.auto,
          size: 200.0,
        ),
      )),
    );
  }
}
