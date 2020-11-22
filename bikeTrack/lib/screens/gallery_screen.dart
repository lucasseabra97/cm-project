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
  //Future<File> imageFile;
  File _image;

  final picker = ImagePicker();
  Image image;
  DBhelper dbhelper;
  List<Photo> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbhelper = DBhelper();
    refreshImages();
  }

  // pickImageFromGallery(){
  //   ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile){
  //     String imgString = base64Image(imgFile.readAsBytes());
  //   })
  // }
  refreshImages() {
    dbhelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final bytes = await pickedFile.readAsBytes();
    if (pickedFile != null) {
      //_image = File(pickedFile.path);
      String imgString = base64Encode(bytes);
      //print(imgString);
      Photo photo = Photo(0, imgString);
      dbhelper.save(photo);
      refreshImages();
    } else {
      print('No image selected.');
    }
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
        title: Text("Gallery Screen"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery();
            },
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Flexible(child: gridView())],
      )),
    );
  }
}
