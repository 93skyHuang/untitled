import 'package:geolocator/geolocator.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/toast.dart';

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

Future<Position> getPosition() async {
  Position? lastP = await getLastPosition();
  logger.i(lastP);
  if (lastP == null) {
    Position position = await getCurrentPosition();
    logger.i(position);
    GetStorageUtils.saveLocation(position);
    return position;
  }
  GetStorageUtils.saveLocation(lastP);
  return lastP;
}

Future<Position> getCurrentPosition() async {
  return await _geolocatorPlatform.getCurrentPosition(
      timeLimit: Duration(seconds: 10));
}

Future<Position?> getLastPosition() async {
  return await _geolocatorPlatform.getLastKnownPosition();
}

Future<bool> checkAndRequestPermission1() async {
  bool serviceEnabled;
  LocationPermission permission;
  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}


///申请权限
Future<bool> checkAndRequestPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      MyToast.show('未开启定位权限！');
      return false;
    }
  }

  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    MyToast.show('请打开手机GPS定位');
    return false;
  }

  if (permission == LocationPermission.deniedForever) {
    MyToast.show('未开启定位权限，如需定位功能请前往手机设置页面进行开启');
    return false;
  }
  return true;
}
