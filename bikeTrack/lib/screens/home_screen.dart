import 'package:bikeTrack/screens/camera_screen.dart';
import 'package:bikeTrack/screens/gallery_screen.dart';
import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'maps_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  static const routeName = '/home';
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MapsScreen(),
    HistoryScreen(),
    CameraScreen(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    var _bottomNavigationItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.map_rounded), label: 'Mapas'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.history), label: 'History'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.camera_alt), label: 'Camara'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.photo_album), label: 'Galeria'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.account_box_rounded), label: 'Profile'),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('BikeTrack'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: _bottomNavigationItems,
            onTap: _onItemTapped,
            currentIndex: _currentIndex,
            selectedFontSize: textTheme.caption.fontSize,
            unselectedFontSize: textTheme.caption.fontSize,
            selectedItemColor: colorScheme.onPrimary,
            unselectedItemColor: colorScheme.onPrimary.withOpacity(0.4),
            backgroundColor: colorScheme.primary));
  }
}
