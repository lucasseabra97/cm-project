import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:bikeTrack/services/photo.dart';
import 'package:bikeTrack/services/dbhelper.dart';
import 'dart:async';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreen createState() => _GalleryScreen();
}

class _GalleryScreen extends State<GalleryScreen> {
  File _image;
  Future<void> imgFromGallery() async {
    //PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    imgFromGallery();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
