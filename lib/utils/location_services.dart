import 'package:location/location.dart';

class LocationServices {

  Location location = Location();

  Future<bool> checkAndRequestLocationServices() async {
    var isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
    }
    return isServiceEnable ;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted ;
    }
    
    return true;
  }


  void getLocationData(void Function(LocationData)? onData){
    location.onLocationChanged.listen(onData);
  }




}