import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_tutor/models/tutor_location_model.dart';
import 'package:my_tutor/screens/student/tutor_detail_by_uid_screen.dart';

class TutorsNearbyScreen extends StatefulWidget {
  const TutorsNearbyScreen({Key? key}) : super(key: key);

  @override
  State<TutorsNearbyScreen> createState() => _TutorsNearbyScreenState();
}

class _TutorsNearbyScreenState extends State<TutorsNearbyScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng pshLatLng = const LatLng(34.0151, 71.5249);
  List<TutorLocationModel> tutorLocations = [];

  static const CameraPosition peshawar = CameraPosition(
    target: LatLng(34.0151, 71.5249),
    zoom: 10.4746,
  );

  Set<Marker> markers = {};
  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  double latitude = 0.0;
  double longitude = 0.0;

  Future getAllTutorsLocation() async {
    DatabaseReference locRef =
        FirebaseDatabase.instance.ref().child('tutor_locations');

    DatabaseEvent locEvent = await locRef.once();
    var locSnapshot = locEvent.snapshot.value;

    if (locSnapshot == null) {
      print('***********************************');
      print('No locations');
      return;
    }

    var locationsFullMap = Map<String, dynamic>.from(locSnapshot as Map);

    for (var tutorLocationMap in locationsFullMap.values) {
      TutorLocationModel tutorLocationModel = TutorLocationModel.fromMap(
          Map<String, dynamic>.from(tutorLocationMap));

      markers.add(Marker(
        markerId: MarkerId(tutorLocationModel.uid),
        position: LatLng(tutorLocationModel.latitude.toDouble(),
            tutorLocationModel.longitude.toDouble()),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
            title: tutorLocationModel.name,
            snippet: tutorLocationModel.qualification,
            onTap: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TutorDetailByUidScreen(uid: tutorLocationModel.uid);
              }));
            }),
      ));

      tutorLocations.add(tutorLocationModel);
    }

    print(tutorLocations.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    getAllTutorsLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Tutors'),
      ),
      body: GoogleMap(
        //mapType: MapType.hybrid,
        initialCameraPosition: peshawar,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _gpsService();
    }

    permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );

    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      Fluttertoast.showToast(msg: 'No permissions granted');
      return;
    }

    final position = await _geoLocatorPlatform.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    print('**********************************');
    print('Latitude $latitude');
    print('Longitude $longitude');
    print('**********************************');

    markers.add(Marker(
      markerId: MarkerId('current location'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
      // TODO: place a custom icon
    ));

    CameraPosition currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 12.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    setState(() {});
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await _geoLocatorPlatform.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Can't get current location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    const AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                    _gpsService();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  /*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await _geoLocatorPlatform.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }
}
