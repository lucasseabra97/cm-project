import 'dart:developer';

import 'package:bikeTrack/screens/history_info.dart';
import 'package:bikeTrack/screens/scan_screen.dart';
import 'package:bikeTrack/services/track_info.dart';
import 'package:bikeTrack/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreen createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {
  List<TrackInfo> _tracks = [];

  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  int _id;

  @override
  void initState() {
    super.initState();

    //_queryDB();

    log(_tracks.length.toString());
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track History"),
      ),
      body: Consumer<DatabaseHelper>(
        builder: (context, value, child) {
          return FutureBuilder(
              future: _queryDB(),
              builder: (context, AsyncSnapshot<List<TrackInfo>> snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      itemCount: _tracks.length,
                      itemBuilder: (context, index) => _buildCards(index));
                }
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ScanPage()));
          },
          child: Icon(Icons.share),
          tooltip: "Scan QR Code"),
    );
  }

  _buildCards(int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: Icon(Icons.terrain),
                title: Text('Track ${index + 1}'),
                subtitle:
                    Text('Distance: ${_tracks[index].distance.toInt()} m'),
                onTap: () {
                  _id = index + 1;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HistoryInfo(index: _tracks[index].id),
                      ));
                }),
          ],
        ),
      ),
    );
  }

  Future<List<TrackInfo>> _queryDB() async {
    _tracks = await _dbHelper.queryAll();
    return _tracks;
  }
}
