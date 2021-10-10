// import 'package:geolocator/geolocator.dart';
//
// final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//
// Future<Position> getCurrentPosition() async {
//   // final hasPermission = await _handlePermission();
//   return await _geolocatorPlatform.getCurrentPosition();
// }
//
// ///需要先判断是否有权限
// Future<bool> _handlePermission() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Test if location services are enabled.
//   serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return false;
//   }
//
//   permission = await _geolocatorPlatform.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await _geolocatorPlatform.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return false;
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     return false;
//   }
//   return true;
// }