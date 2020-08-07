import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_maps/checkboxslist.dart';
import 'package:flutter_maps/homepage.dart';
import 'package:flutter_maps/maproute.dart';
import 'package:flutter_maps/models/latLongModel.dart';
import 'package:flutter_maps/pages/recent_locations.dart';
import 'package:flutter_maps/pages/root_page.dart';
import 'package:flutter_maps/polymap.dart';
import 'package:flutter_maps/polysharedlist.dart';
import 'package:flutter_maps/polysharemap.dart';
import 'package:flutter_maps/services/authentication.dart';
import 'package:flutter_maps/sharedlist.dart';
import 'package:flutter_maps/sharemap.dart';
import 'package:flutter_maps/tabbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter_maps/models/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Maps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));

    //MyHomePage(auth: new Auth()));
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;
  MyHomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LocationDataNew> _locationList;
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
  FirebaseUser user;
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationList = new List();
    _locationQuery = _database
        .reference()
        .child("location")
        .orderByChild("userId")
        .equalTo(widget.userId);
    print('userid = ${widget.userId}');
    _onLocationAddedSubscription =
        _locationQuery.onChildAdded.listen(onEntryAdded);
    _onLocationChangedSubscription =
        _locationQuery.onChildChanged.listen(onEntryChanged);

    getCurrentLocation();
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

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
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
      // circle = Circle(
      //     circleId: CircleId("car"),
      //     radius: newLocalData.accuracy,
      //     zIndex: 1,s
      //     strokeColor: Colors.blue,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(70));
    });
  }

   addLocationToRecentsList(double lat, double lang)async {
    Map<dynamic,dynamic> getRecentList;
    final dbRef =
        FirebaseDatabase.instance.reference().child("RecentPlaceslist").child(widget.userId);
  await  dbRef.once().then((DataSnapshot snapshot) {
          getRecentList = snapshot.value;
    });
      if (getRecentList == null) {
       addNewListToNewUser(lat,lang);
      } else {
        getDataList(getRecentList,lat,lang);
      }
  }

  addNewListToNewUser(double lat,double lang){
 LatLongmodel model = new LatLongmodel();
        model.latitude = lat;
        model.longitude = lang;
        model.userName = widget.userId;
        String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
        model.datetime = formattedDate;
        LatListmodel listModel = new LatListmodel();
        List<Map<String, dynamic>> latlistModel = [];
        latlistModel.add(model.toMap());
        listModel.listData = latlistModel;
        listModel.user = widget.userId;
        _database
            .reference()
            .child("RecentPlaceslist")
            .child(widget.userId)
            .set(listModel.toMap());
  }

  getDataList(dynamic data, double lat, double lang) {
    LatListmodel mainModel = new LatListmodel();
    List<Map<String, dynamic>> mainSubData = [];
    if (data != null) {
      if (widget.userId == data['user']) {
        mainModel.user = data['user'];
        List<dynamic> listData = data['listData'];
        for (var i = 0; i < listData.length; i++) {
          mainSubData.add({
            'latitude': listData[i]['latitude'],
            'longitude': listData[i]['longitude'],
            'user': listData[i]['user'],
            'date': listData[i]['date']
          });
        }
        mainModel.listData = mainSubData;
        if (mainModel != null) {
        if (mainModel.user != null) {
          if (mainModel.user == widget.userId) {
            if (mainModel.listData != null) {
              bool isExisted = false;
              for (var i = 0; i < mainModel.listData.length; i++) {  
                
                if (mainModel.listData[i]['latitude'] == lat &&
                    mainModel.listData[i]['longitude'] == lang) {
                      isExisted = true;
                } 
              }
              if(!isExisted)
              {
                String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
             mainSubData.add({
            'latitude': lat,
            'longitude': lang,
            'user': widget.userId,
            'date': formattedDate
               });
              }
            }
          }
        }
      }
      }
      else
      {
        
      }
      
    }  
                _database
            .reference()
            .child("RecentPlaceslist")
            .child(widget.userId)
            .update(mainModel.toMap());
    
  }

  void getCurrentLocation() async {
    user = await widget.auth.getCurrentUser();
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
            addLocationToRecentsList(
              newLocalData.latitude, newLocalData.longitude);
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          addNewLocationItem(newLocalData.latitude, newLocalData.longitude);
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

    setState(() {});
    if (_locationList.length == 0) {
      LocationDataNew todo =
          new LocationDataNew(lat, lang, widget.userId, user.email);
      //  _database.reference().child("location").push().set(todo.toJson());
      _database
          .reference()
          .child("location")
          .child(widget.userId)
          .set(todo.toJson());
    } else {
      updateLocationItem(lat, lang);
    }
  }

  updateLocationItem(double lat, double lang) {
    //Toggle completed
    String todoId = _locationList[0].key;
    LocationDataNew todo =
        new LocationDataNew(lat, lang, widget.userId, user.email);
    _database.reference().child("location").child(todoId).set(todo.toJson());


final dbRef = FirebaseDatabase.instance
        .reference()
        .child("location")
       .orderByChild("userId")
       .equalTo(widget.userId);
  //  dbRef.onValue.listen((event) {
  //  var snapshot = event.snapshot;
      
      
//
   dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          if (key == widget.userId)
          {
            shareddataUpdate(lat,lang);
        }
        });
      }
    });
    
  } 
  void shareddataUpdate(double lat, double lang)
  {
LocationDataNew todo =
        new LocationDataNew(lat, lang, widget.userId, user.email);
    _database.reference().child("shareddata").child(widget.userId).set(todo.toJson());
  }

  share() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SharemapPage(
                userId: widget.userId,
                user: user,
                value: true,
              )),
    );
  }

  list() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyListPage(
                userid: widget.userId,
              )),
    );
  }

  sharedlist() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TabHomePage()),
    );
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
        actions: <Widget>[
          new FlatButton(
              // child: new Text('Logout',
              //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              child: new Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 24.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: signOut),
          new FlatButton(
              // child: new Text('Share',
              //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              child: new Icon(
                Icons.share,
                color: Colors.white,
                size: 24.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: share),
          new FlatButton(
              // child: new Text('List',
              //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              child: new Icon(
                Icons.view_list,
                color: Colors.white,
                size: 24.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: list),
          new FlatButton(
              // child: new Text('List',
              //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              child: new Icon(
                Icons.favorite,
                color: Colors.white,
                size: 24.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: sharedlist),
              
        ],
      ),
      body:  Stack(
        children: <Widget>[ GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        // circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child:  Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.topRight,child: _buildPolyMapButton()),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.topRight,child: _buildRecentPlaceslistMapButton()),
          ),
        ]))
        ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
  Widget _buildPolyMapButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: GestureDetector(
        child:  Icon(Icons.polymer),
                     
        onTap: () {
         Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PolyMapSample(userId: widget.userId,auth: widget.auth,)),
    );
        },
      ),
    );
  }
  Widget _buildRecentPlaceslistMapButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: GestureDetector(
        child:  Icon(Icons.recent_actors),
                     
        onTap: () {
          Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RecentLocationComponenet(userid: widget.userId)),
    );
        },
      ),
    );
  }
}
