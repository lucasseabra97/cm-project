import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreen createState() => _GalleryScreen();
}

class _GalleryScreen extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text("Gallery Screen")
          ),
    );
  }
}