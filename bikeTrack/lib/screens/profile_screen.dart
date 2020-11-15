import 'package:flutter/material.dart';
import 'dart:io';
import 'qrGenerator_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //body: Center(child: Text("Profile Screen")),
        body: SafeArea(
        child: Container(
      child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
                child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://machinecurve.com/wp-content/uploads/2019/07/thispersondoesnotexist-1-1022x1024.jpg"))),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            color: Colors.amber),
                        child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              getImage();
                            })))
              ],
            )),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 30),
            buildTextField("Full Name", "Mosh Hamedani", false),
            buildTextField("E-mail", "mhd@bomdia.pt", false),
            buildTextField("Password", "**********", true),
            OutlineButton(
              highlightColor: Colors.amber,
              splashColor: Colors.amber,
              borderSide: BorderSide(
                width: 3,
                color: Colors.amber,
              ),
              shape: StadiumBorder(),
              child: Text(
                "Generate QR",
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QRGenerator()));
              },
            ),
          ],
      ),
    ),
        ));
  }

  Widget buildTextField(
      String labelText, String placeholder, bool ispasstextfiel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: ispasstextfiel ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: ispasstextfiel
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
