# Google_map_app

## Google map in UI 


### 1 - Google map controller

we use google map controller to operate some functions such as dispose() and animateCamera ({use camera update and named contructor 'update camera'}) using to move the view to another location by LatLng objects 

### 2 - initailCameraPosition

use to show the first view when open google map by put it in initState

### 3 - Camera target bounds 

use this attribute to define all area which we want to show it and don't move away of it 

### 4 - Elevated Button

use this attribute to move the camera (view) to a new location by use google map controller and animate camera to move to new LatLng 

### 5 - Night map style ()

- first we put a json style file in assets folder and create file which contain json code 
- second create an async function return Future<String> and its body is contain a String named nightMapStyle 
this is equal (use DeafaultAssestsBundle to load the json file by its path) and return nightMapStyle
- third call this function in style that is attribute in google map 

### 6 - Markers

- first we create models folder and create place model (id - name - LatLng) and create list of places 
- second create Set of Markers (this is builtIn objects in google map use to create markers use in maps)
- third create initMarker() and its body is 
   * customMarkerImage(var) is equal => BitmapDescriptor.bytes ( getImageFromRawData to load the image of customer marker and its size )
   * create myMarkers(map) to convert places location to markers by put marker image , position and id to Marker object 
   * convert myMarkers(map) to Set and addAll to markers(Set)
- fourth put marker(Set) to marker(attribute) in google map 

### 7 - initPolyLines() 

polyline are builtIn object in google map
polylines are straight lines in map determined by points in map with attributes such as [ color - zIndex - width - geodesic - endCap - polylineId - points ]
    * zIndex : is using to determine prority of the polylines if there exist in same point
    * geodesic : using to determine if the lines make earth curve in very long polylines or no
    * endCap : using to determine the end of lines what will shown
    * points : using to determine which path the polylines will taken

we create Set of polylines and shown it in google map


### 8 - initPolygones()

- this useful is Draw a custom polygon through geographical locations on the map
- we can use holes attribute to draw holy in current polygon

### 9 - initDeterminedCircule

- Creates an immutable representation of a [Circle] to draw on [GoogleMap].
- it has some attriubte such as [radius - circleId - center]
    * radius : to determine how much miters this circule will cover
    * center : to determine the central point for this circule

### 10 - Location (object)

- it is the main point access Location plugin 
- it is offer a lot of useful functions 
such as : [ changeSettings - enableBackgroundMode - getLocation - requestPermission - requestService ]        

- we use it in next functions 

### 11 - checkAndRequestLocationServices()

- we create isServiceEnable (bool) is equal => use location (object) and serviceEnabled() to show if location services is enable in the phone
- if isServiceEnable is true we continue another functions 
else we request the location services by location.requestService();
- if the user denied the request , we show an error message bar

### 12 - checkAndRequestLocationPermission()

- we create permissionState (bool) is equal => use location (object) and hasPermission to show if location services permission for our app is enable in the phone
- if permissionState is true we continue another functions 
else we request the permission location services by location.requestPermission();
- if the user denied the request or select deniedForever , we return permissionState either true or false 

### 13 - getLocationData()

- first we want to get the new marker's location every 2 seconds so we use location.changeSettings(distanceFilter: 2);
- we use onLocationChanged.listen to update the new location of marker every 2 seconds in locationData (LocationData in listen function)
- we create a new camera position and get LatLng by locationData and also add it in marker to move to the new position 
- use setState((){}) to update the UI and show it in the map 
- use googleMapController to animate the camera to a new position

### 14 - updateMyLocation()

this is a collection of methods which is used to request location Services and permission to use it and update the current location every 2 seconds

