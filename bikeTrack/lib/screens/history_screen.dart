import 'dart:developer';

import 'package:bikeTrack/services/track_info.dart';
import 'package:bikeTrack/services/database_helper.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreen createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {

 int n_cards = 5;

 List<TrackInfo> _tracks = [];

 DatabaseHelper db_helper = DatabaseHelper.instance;

 @override
 void initState(){
   super.initState();
  _queryDB();
 }

 void dispose(){
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _tracks.length,
        itemBuilder: (context, index) => _buildCards(index)
      ),
    );
  }
  
  _buildCards(int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                leading: Icon(Icons.terrain),
                title: Text('Track ${index+1}'),
                subtitle: Text('Distance: ${_tracks[index].distance}')
                /* onTap: , */
                ),
              ],
            ),
          ),
    );
  }

  void _queryDB() async {
    _tracks = db_helper.queryAll() as List<TrackInfo>;
  }
}
