import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeViewModel extends ChangeNotifier {

  Completer<GoogleMapController> controller = Completer();
  CameraPosition bukhara = const CameraPosition(
    target: LatLng(39.77472, 64.42861),
    zoom: 14,
  );
  final Set<Marker> markers = {};
  Set<Polygon> polygons = HashSet<Polygon>();
  List<LatLng> userPoints = [];
  bool isAddingPolygon = false;
  MapType mapType=MapType.normal;
  LatLng? currentPosition;
  final locationController = Location();

  void setTemporaryPolygon(List<LatLng> points) {
      polygons.removeWhere((polygon) => polygon.polygonId.value == 'temporary_polygon');
      if (points.isNotEmpty) {
        polygons.add(
          Polygon(
            polygonId: const PolygonId('temporary_polygon'),
            points: points,
            strokeColor: Colors.deepOrange,
            strokeWidth: 5,
            fillColor: Colors.blue.withOpacity(0.1),
            geodesic: true,
          ),
        );
      }
    notifyListeners();
  }

  void setMapType(MapType type) {
    mapType = type;
    notifyListeners();
  }

  void savePolygon() {
      polygons.removeWhere((polygon) => polygon.polygonId.value == 'temporary_polygon');
      polygons.add(
        Polygon(
          polygonId: PolygonId(DateTime.now().millisecondsSinceEpoch.toString()),
          points: List<LatLng>.from(userPoints),
          strokeColor: Colors.deepOrange,
          strokeWidth: 5,
          fillColor: Colors.blue.withOpacity(0.1),
          geodesic: true,
        ),
      );
      userPoints.clear();
      isAddingPolygon = false;
    notifyListeners();
  }

  void onClear() {
    userPoints.clear();
    polygons.clear();
    notifyListeners();
  }

  void addPolygon() {
    isAddingPolygon = true;
    userPoints.clear();
    notifyListeners();
  }

  void clickMap(point){
    if (isAddingPolygon) {
        userPoints.add(point);
        setTemporaryPolygon(userPoints);
    }
    notifyListeners();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {},).onError((e,b){print('error: $e ');});
    return await Geolocator.getCurrentPosition();
  }

  void setMyLocation(value) async {
    markers.add(
        Marker(
            markerId: MarkerId('2'),
            position: LatLng(value.latitude,value.longitude),
            infoWindow: InfoWindow(title: 'Bu men')
        )
    );
    CameraPosition cameraPosition = CameraPosition(target: LatLng(value.latitude,value.longitude),zoom: 20);
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }
}