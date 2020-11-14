import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class MapsScreen extends StatefulWidget {
  static const routeName = '/maps';
  @override
  _MapsScreen createState() => _MapsScreen();
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class _MapsScreen extends State<MapsScreen> with AutomaticKeepAliveClientMixin{
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoords = [];
  PolylinePoints polylinePoints;

  String googleAPIKey = "AIzaSyCUWJ02dCx6IJEOHDQdD45Dc7zREMFynhQ";

  BitmapDescriptor sourceIcon;

  BitmapDescriptor destinationIcon;

  LocationData initialposition;

  LocationData currentLocation;

  LocationData destinationLocation;

  Location location;

  bool _buttonPressed = false;

  StreamSubscription _locationSubscription;


  @override
  void initState() {
    super.initState();

    location = new Location();

    polylinePoints = PolylinePoints();

    setSourceAndDestinationIcons();

    setInitialLocation();
  }

  void _listenLocation(){
     _locationSubscription = location.onLocationChanged.listen((LocationData cLoc) {
      initialposition = currentLocation;
      currentLocation = cLoc;
      updatePinOnMap();
    });
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = BitmapDescriptor.defaultMarker;

    destinationIcon = BitmapDescriptor.defaultMarker;
  }

  void setInitialLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    initialposition = await location.getLocation();

    currentLocation = LocationData.fromMap({
      "latitude": SOURCE_LOCATION.latitude,
      "longitude": SOURCE_LOCATION.longitude
    });

    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    return Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                compassEnabled: false,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showPinsOnMap();
                }),
            ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ), 
                  ),
                  width: MediaQuery.of(context).size.width * 0.95,
                   child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _setLocationListening,
                            color: Colors.amber,
                            child: Text("Start/Stop Tracking"),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              )
          ]),
    );
  }

  void _setLocationListening(){
    _buttonPressed = !_buttonPressed;
    if(_buttonPressed){
      _listenLocation();
    }
    else{
      _locationSubscription.cancel();
    }
    log(_buttonPressed.toString());
  }

  void showPinsOnMap() {
    if (currentLocation != null) {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));
    }
  }

  void setPolyLines() async {
    log("calculating result");
    log(currentLocation.toString());
    log(initialposition.toString());
  
    if (currentLocation != null && initialposition != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(initialposition.latitude, initialposition.longitude),
        PointLatLng(
            currentLocation.latitude, currentLocation.longitude),
      );
      log(result.points.toString());
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoords.add(LatLng(point.latitude, point.longitude));
        });
        if(mounted){
          setState(() {
          _polylines.add(Polyline(
              width: 5, // set the width of the polylines
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoords));
        });
        }
      }
    }
  }

  void updatePinOnMap() async {
    if(mounted){
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    
      setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));
    });
    setPolyLines();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
