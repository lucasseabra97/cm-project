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
  DBhelper dbhelper;
  List<Photo> images;
  final _picker = ImagePicker();
  PickedFile _pf;

  @override
  void initState() {
    super.initState();
    images = [];
    dbhelper = DBhelper();
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

    setState(() {
      _pf = image;
    });
  }

  Future<void> imgFromGallery() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _pf = image;
    });
  }

  // Future<void> pickImageFromGallery() async {
  //   final pickedFile = await _picker.getImage(source: ImageSource.gallery);
  //   final bytes = await pickedFile.readAsBytes();
  //   if (pickedFile != null) {
  //     //_image = File(pickedFile.path);
  //     String imgString = base64Encode(bytes);
  //     //print(imgString);

  //     Photo photo = Photo(photoName: imgString);

  //     dbhelper.save(photo);
  //     refreshImages();
  //   } else {
  //     print('No image selected.');
  //   }
  // }

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
      body: Column(
        children: <Widget>[
          Expanded(
              child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            // children: <Widget> [
            //   _pf == null
            //     ? Text('No image selected.')
            //     : Image.file(_pf)
            //   ]
          )),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.camera,
                      size: 50,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      pickImageFromCamera();
                    }),
                SizedBox(
                  width: 60,
                ),
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
