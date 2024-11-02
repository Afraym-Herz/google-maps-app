import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id ;
  final String name ;
  final LatLng latLng ;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
     name: "مطعم و كافية بابلو",
      latLng: const LatLng(31.234216, 29.950389) ,
      ) ,
      PlaceModel(
    id: 2,
     name: "مستشفي الهدايا",
      latLng: const LatLng(31.2333528, 29.95038) ,
      ) ,
      PlaceModel(
    id: 3,
     name: "شركة فرفاريكو",
      latLng: const LatLng(31.23421656,29.950389 ) ,
      ) ,
];