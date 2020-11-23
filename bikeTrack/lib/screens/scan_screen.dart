import 'package:bikeTrack/services/database_helper.dart';
import 'package:bikeTrack/services/track_info.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String camaraScanResult;

  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<String> subCameraResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          padding: EdgeInsets.all(15.0),
          onPressed: () async {
            String cameraScanResult = await scanner.scan();
            subCameraResult = cameraScanResult.split(",");

            _saveToDB(
                subCameraResult[0],
                subCameraResult[1],
                subCameraResult[2],
                subCameraResult[3],
                subCameraResult[4],
                subCameraResult[5]);

            Navigator.of(context).pop();
          },
          child: Text(
            "Open Scanner",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.amber, width: 3.0),
              borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  Future<void> _saveToDB(String avgSpeed, String distance, String initLat,
      String initLng, String fLat, String fLng) async {
    TrackInfo trackInfo = TrackInfo();
    trackInfo.avgSpeed = double.parse(avgSpeed);
    trackInfo.distance = double.parse(distance);
    trackInfo.initPosLat = double.parse(initLat);
    trackInfo.initPosLng = double.parse(initLng);
    trackInfo.fPosLat = double.parse(fLat);
    trackInfo.fPosLng = double.parse(fLng);
    int id = await _dbHelper.insert(trackInfo);
  }
}
