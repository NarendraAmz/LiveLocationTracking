import 'dart:async';
import 'dart:math' as Math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/maproute.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PolyshareMapSample extends StatefulWidget {
 PolyshareMapSample({Key key, this.userId}) : super(key: key);

  final String userId;
  
  @override
  State<PolyshareMapSample> createState() => PolyshareMapSampleState();
}

class PolyshareMapSampleState extends State<PolyshareMapSample> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  List<LatLng> polyPoints = [];
  Location myLocation;
  String dropdownValue = 'Sq_Feet';
  FirebaseUser user;
  List<Map<String, dynamic>> latdatamodel = [];

  List<String> spinnerItems = [
    'Sq_Feet',
    'Sq_Yard',
    'Sq_Metre',
    'Sq_Km',
    'Sq_Mile',
    'Acres',
    'Cents',
  ];
  static final CameraPosition _position1 = CameraPosition(
      bearing: 192.833,
//      target: LatLng(19.2215, 73.1645),
      target: LatLng(17.812350, 83.199170),
      zoom: 12.0,
      tilt: 59.440);
  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
//      target: LatLng(17.8055, 83.2089),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onTapMarkerAdd(LatLng latLng) {
    setState(() {
      polyPoints.add(latLng);
      _drawPolygon(polyPoints);
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(title: 'title', snippet: 'snippet'),
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (LatLng latLng) {
            print(latLng);
            print(latLng.toString());
          },
        ),
      );
    });
  }

  _clearAllMarkers() {
    setState(() {
      _markers.clear();
      _polygons.clear();
      polyPoints.clear();
    });
  }

  _drawPolygon(List<LatLng> listLatLng) {
    setState(() {
      _polygons.add(Polygon(
          polygonId: PolygonId('123'),
          points: listLatLng,
          fillColor: Colors.transparent,
          strokeColor: Colors.red));
    });
  }

  void _calculateArea(String data) {
    polyPoints.add(polyPoints[0]);
    print(calculatePolygonArea(polyPoints));
    double squareFeet = calculatePolygonArea(polyPoints) * 43560;
    double squareYard = calculatePolygonArea(polyPoints) * 4840;
    double squareMetre = calculatePolygonArea(polyPoints) * 4047;
    double squareKm = calculatePolygonArea(polyPoints) / 247;
    double squareMile = calculatePolygonArea(polyPoints) / 640;
    double cents = calculatePolygonArea(polyPoints) * 100;

    if (data == "Sq_Feet") {
      toastArea("squre Feet", squareFeet);
    } else if (data == "Acres") {
      toastArea("Acres", calculatePolygonArea(polyPoints));
    } else if (data == "Sq_Yard") {
      toastArea("Square Yard", squareYard);
    } else if (data == "Sq_Metre") {
      toastArea("Square Metre ", squareMetre);
    } else if (data == "Sq_Km") {
      toastArea("Square Kilometre ", squareKm);
    } else if (data == "Sq_Mile") {
      toastArea("Square Mile ", squareMile);
    } else if (data == "Cents") {
      toastArea("Cents ", cents);
    }
  }

  void toastArea(String name, double val) {
    Fluttertoast.showToast(
        msg: val.toString() + name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static double calculatePolygonArea(List coordinates) {
    double area = 0;

    if (coordinates.length > 2) {
      for (var i = 0; i < coordinates.length - 1; i++) {
        var p1 = coordinates[i];
        var p2 = coordinates[i + 1];
        area += convertToRadian(p2.longitude - p1.longitude) *
            (2 +
                Math.sin(convertToRadian(p1.latitude)) +
                Math.sin(convertToRadian(p2.latitude)));
      }

      area = area * 6378137 * 6378137 / 2;
    }

    return area.abs() * 0.000247105; //sq meters to Acres
  }

  static double convertToRadian(double input) {
    return input * Math.pi / 180;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
      heroTag: icon.toString(),
    );
  }

  void databaseHandling() {
  // timercallMethod();
    final dbRef = FirebaseDatabase.instance.reference().child("polyshareddata");
      
    // dbRef.orderByChild("userId").equalTo(widget.userId).once();
    //  dbRef.orderByChild("userId").equalTo(widget.userId).once();

//  _onLocationAddedSubscription = _locationQuery.onChildAdded.listen(onEntryAdded);
//     _onLocationChangedSubscription =
//         _locationQuery.onChildChanged.listen(onEntryChanged);
dbRef.onValue.listen((event) {
   var snapshot = event.snapshot;
      
      
//
   // dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
         // List lists= [];
        values.forEach((key, value) {
         // print(values["lat"]);
         if(key ==  widget.userId)
         {
         List listvalues = value;
                    // lists.add(values);
                    for (var i=0; i<listvalues.length;i++)
                    {
                         LatLng latlng =  LatLng(listvalues[i]['lat'],listvalues[i]['lang']);
           _onTapMarkerAdd(latlng);
                    }
         }
                    
          //         listvalues.forEach((index, listvales) {
          //            LatLng latlng =  LatLng(listvales[index]['lat'],listvales[index]['lang']);
          //  _onTapMarkerAdd(latlng);
          //         });
       
          // if (_locationList.length
          //   _locationList.removeAt(0);
          // }
          // _locationList.add(values);
          // print(_locationList);
          // if (widget.value == true) {
          //   addNewLocationItem(
          //       _locationList[0]['lat'], _locationList[0]['lang']);
          // }
       
        });
          
      }
    });

    setState(() {});
  }

    

  @override
  Widget build(BuildContext context) {
      databaseHandling();
    return new Scaffold(
      appBar: AppBar(title: Text('Poly Share map'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(17.812350, 83.199170), zoom: 11.0),
            mapType: _currentMapType,
            markers: _markers,
            polygons: _polygons,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            // onTap: (LatLng latLng) {
            //   _onTapMarkerAdd(latLng);
            // },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  // button(sharemap, Icons.share),
                  // SizedBox(height: 16.0),
                  // button(_onMapTypeButtonPressed, Icons.map),
                  // SizedBox(height: 16.0),
                  // button(_goToPosition1, Icons.location_searching),
                  // SizedBox(height: 16.0),
                  // button(_clearAllMarkers, Icons.location_off),
//                  SizedBox(height: 16.0),
//                  button(, Icons.av_timer),
                  RaisedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => SectorDialog(),
                        );
                      },
                      icon: Icon(Icons.message),
                      color: Colors.white,
                      textColor: Colors.blue,
                      label: Text("PopUp!")),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 5,
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
//                    child:Container(
//                      padding: EdgeInsets.symmetric(horizontal: 10.0),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(15.0),
//                        border: Border.all(
//                            color: Colors.red, style: BorderStyle.solid, width: 0.80),
//                      ),
                    onChanged: (String data) {
                      setState(() {
                        dropdownValue = data;
                      });
                      _calculateArea(data);
                    },
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

 
}

class SectorDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SectorDialogState();
}

class SectorDialogState extends State<SectorDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 300,
            height: 210,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
//              padding: const EdgeInsets.fromLTRB(50,100,50,50),
              padding: const EdgeInsets.all(50.0),

              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter survey Number',
                    ),
                  ),
                  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.orangeAccent,
                      child: Text('Submit'),
                      onPressed: () {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Survey Number is" +
                                nameController.text.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
