import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:bikeTrack/services/photo.dart';
import 'package:bikeTrack/services/dbhelper.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreen createState() => _CameraScreen();
}

class _CameraScreen extends State<CameraScreen> {
  DatabaseHelperImages dbhelper;
  List<Photo> images;
  final _picker = ImagePicker();
  PickedFile _pf;
  PickedFile _image;
  List<File> _images;
  @override
  void initState() {
    super.initState();
    images = [];
    dbhelper = DatabaseHelperImages.instance;
    refreshImages();
  }

  refreshImages() {
    dbhelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  Future<void> pickImageFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    final bytes = await image.readAsBytes();
    if (image != null) {
      String imgString = base64Encode(bytes);
      Photo photo = Photo(imgString);
      dbhelper.save(photo);
    }
    refreshImages();
  }

  gridView() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: images.map((photo) {
              return imageFromBase64String(photo.photoName);
            }).toList()));
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera screen'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                pickImageFromCamera();
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Flexible(child: gridView())],
        ),
      ),
    );
  }
}
