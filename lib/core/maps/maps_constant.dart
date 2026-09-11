import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
   world view 0 -> 3
   country view 4->6
   government view 7 -> 9
   city view 10 -> 12
   street view 13 -> 17
   building view 18 -> 20
* */
abstract class MapsConstant {
  static const LatLng capitalLatLng =
      LatLng(2.0392989136634254, 45.33361056013564);
  static const LatLng northEastLatLng =
      LatLng(12.88207193798688, 51.277674685140475);
  static const LatLng southWestLatLng =
      LatLng(-2.0101051849262124, 40.10265824169395);

  static const double worldView1 = 0;
  static const double worldView2 = 1;
  static const double worldView3 = 2;
  static const double worldView4 = 3;

  static const double countryView1 = 4;
  static const double countryView2 = 5;
  static const double countryView3 = 6;

  static const double governmentView1 = 7;
  static const double governmentView2 = 8;
  static const double governmentView3 = 9;

  static const double cityView1 = 10;
  static const double cityView2 = 11;
  static const double cityView3 = 12;

  static const double streetView1 = 13;
  static const double streetView2 = 14;
  static const double streetView3 = 15;
  static const double streetView4 = 16;
  static const double streetView5 = 17;

  static const double buildingView1 = 18;
  static const double buildingView2 = 19;
  static const double buildingView3 = 20;

  static const String myLocationMarkerId = 'myLocationMarkerId';

  static const String countryCode = 'so';
}
