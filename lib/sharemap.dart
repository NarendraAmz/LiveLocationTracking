import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_maps/models/todo.dart';

class SharemapPage extends StatefulWidget {
  
SharemapPage({Key key, this.userId})
      : super(key: key);

  
  final String userId;
  @override
  _SharemapPageState createState() => _SharemapPageState();
}

class _SharemapPageState extends State<SharemapPage> {
  List _locationList;
    final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
 StreamSubscription<Event> _onLocationAddedSubscription;
  StreamSubscription<Event> _onLocationChangedSubscription;
  Query _locationQuery;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationList = new List();
    // _locationQuery = _database
    //     .reference()
    //     .child("location");
    //    // .orderByChild("userId")
    //     //.equalTo('QqU5i58Ek9WC3FS7SkSioYNJnPs1');
    // _onLocationAddedSubscription = _locationQuery.onChildAdded.listen(onEntryAdded);
    // _onLocationChangedSubscription =
    //     _locationQuery.onChildChanged.listen(onEntryChanged);

  // getCurrentLocation();
   final dbRef = FirebaseDatabase.instance.reference().child("location");
   dbRef.orderByChild("userId").equalTo(widget.userId).once();
  //  dbRef.orderByChild("userId").equalTo(widget.userId).once();
    
 _onLocationAddedSubscription = _locationQuery.onChildAdded.listen(onEntryAdded);
    _onLocationChangedSubscription =
        _locationQuery.onChildChanged.listen(onEntryChanged);
dbRef.once().then((DataSnapshot snapshot){
  Map<dynamic, dynamic> values = snapshot.value;
     values.forEach((key,values) {
      print(values["lat"]);
       _locationList.add(values);
        print(_locationList);
       locupdateMarkerAndCircle();
    });
 });
  }
  Future<void> locupdateMarkerAndCircle() async {
   
     Uint8List imageData = await getMarker();
    LatLng latlng = LatLng(_locationList[0]['lat'],_locationList[0]['lang']);
     if (_controller != null) {
          _controller.moveCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: latlng,
              tilt: 0,
              zoom: 18.00)));
             // addNewLocationItem(newLocalData.latitude,newLocalData.longitude);
          //updateMarkerAndCircle(newLocalData, imageData);
        }
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("homesd"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
    
  }
  onEntryChanged(Event event) {
    var oldEntry = _locationList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _locationList[_locationList.indexOf(oldEntry)] =
          LocationDataNew.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
     //if (_locationList.length == 0) {
    setState(() {
      _locationList.add(LocationDataNew.fromSnapshot(event.snapshot));
    });
    // }
  }
  

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      // var location = await _locationTracker.getLocation();

     // updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
            //  addNewLocationItem(newLocalData.latitude,newLocalData.longitude);
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
   addNewLocationItem(double lat, double lang) {
   // final dbRef = FirebaseDatabase.instance.reference().child("location");
   
     
 
// dbRef.once().then((DataSnapshot snapshot){
//   Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key,values) {
//       print(values["lat"]);
//       // _locationList.add(values);
//     });
//  });
   setState(() { });
     if (_locationList.length == 0) {
      LocationDataNew todo = new LocationDataNew(lat,lang,widget.userId);
      _database.reference().child("location").push().set(todo.toJson());
     }
     else
     {
       updateLocationItem(lat, lang);
     }
    
  }
  updateLocationItem(double lat, double lang) {
    //Toggle completed
   String todoId = _locationList[0].key;
  LocationDataNew todo = new LocationDataNew(lat,lang,widget.userId);
      _database.reference().child("location").child(todoId).set(todo.toJson());
    
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
        ),
      
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

      ),
      
    );
  }
}