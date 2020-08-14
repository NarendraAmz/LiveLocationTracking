import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/models/todo.dart';
import 'package:flutter_maps/services/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CheckboxListPage extends StatefulWidget {
  CheckboxListPage({Key key, this.userid,this.auth}) : super(key: key);
  final String userid;
 final BaseAuth auth;

  @override
  _CheckboxListPageState createState() => _CheckboxListPageState();
}

class _CheckboxListPageState extends State<CheckboxListPage> {
  List lists;
  bool isSelected = false;
  int selectedindex = 0;
   final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query _locationQuery;
  FirebaseUser user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lists = new List();
  inputData();
      // _locationQuery = _database.reference().child("Recentshareddata")
      //  .orderByChild("userId")
      // .equalTo(widget.userid);
  }
void share()
{
  if (isSelected == true)
  {
  databaseHandling();
  }
  else
  {
    Fluttertoast.showToast(msg: 'Please Select Row');
  }

}
void inputData() async {
     user = await widget.auth.getCurrentUser();
   
    // here you write the codes to input the data into firestore
  }
void databaseHandling() {
  // timercallMethod();
  
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child("location")
       .orderByChild("userId")
       .equalTo(widget.userid);
    // dbRef.orderByChild("userId").equalTo(widget.userId).once();
    //  dbRef.orderByChild("userId").equalTo(widget.userId).once();

//  _onLocationAddedSubscription = _locationQuery.onChildAdded.listen(onEntryAdded);
//     _onLocationChangedSubscription =
//         _locationQuery.onChildChanged.listen(onEntryChanged);
 dbRef.once().then((DataSnapshot snapshot) {
   //var snapshot = event.snapshot;
      
      
//
   // dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(values["lat"]);
          // if (_sharelocationList.length > 0) {
          //   _sharelocationList.removeAt(0);
          // }
          //  print(_sharelocationList);
          // _sharelocationList.add(values);
          // print(_sharelocationList);
          
            addNewLocationItem(
                values["lat"],values["lang"]);
          
         
        });
      }
    });

    //setState(() {});
  }
addNewLocationItem(double lat, double lang)  {
    // final dbRef = FirebaseDatabase.instance.reference().child("location");

// dbRef.once().then((DataSnapshot snapshot){
//   Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key,values) {
//       print(values["lat"]);
//       // _locationList.add(values);
//     });
//  });
var newuserid = lists[selectedindex]['userId'];

  //  // setState(() {});
  //   if (_sharelocationList.length == 0) {
  //     LocationDataNew todo =
  //         new LocationDataNew(lat, lang, newuserid, '');
  //     //  _database.reference().child("location").push().set(todo.toJson());
  //     _database
  //         .reference()
  //         .child("Recentshareddata")
  //         .child(newuserid)
  //         .set(todo.toJson());
  //          Navigator.pop(context);
  //   } else {
  //     updateLocationItem(lat, lang);
  //   }
  final dbRef = _database
        .reference()
        .child("Recentshareddata")
       .orderByChild("shareduserId")
       .equalTo(newuserid);
      //  .orderByChild("shareduserId")
      //  .equalTo(widget.userid);
    // dbRef.orderByChild("userId").equalTo(widget.userId).once();
    //  dbRef.orderByChild("userId").equalTo(widget.userId).once();

//  _onLocationAddedSubscription = _locationQuery.onChildAdded.listen(onEntryAdded);
//     _onLocationChangedSubscription =
//         _locationQuery.onChildChanged.listen(onEntryChanged);
  dbRef.once().then((DataSnapshot snapshot) {
  
      
      
//
   // dbRef.once().then((DataSnapshot snapshot) {
    //  Map<dynamic, dynamic> values = snapshot.value;
      if (snapshot.value != null) {
        snapshot.value.forEach((key, values) {
          print(values["lat"]);
         
        if ((values['userId'] == widget.userid) && (values['shareduserId']== newuserid))
        {
   
    RecentLocationDataNew todo =
          new RecentLocationDataNew(lat, lang, widget.userid, user.email,newuserid);
   _database.reference().child("Recentshareddata").child(values['shareduserId']).set(todo.toJson());
    Navigator.pop(context);
        }
        else
        {
           RecentLocationDataNew todo =
          new RecentLocationDataNew(lat, lang, widget.userid, user.email,newuserid);
      //  _database.reference().child("location").push().set(todo.toJson());
      _database
          .reference()
          .child("Recentshareddata")
          .child(newuserid)
          .set(todo.toJson());
           Navigator.pop(context);
        }
         
        });
        

      }
      else
      {
        print('dt ELse');
         RecentLocationDataNew todo =
          new RecentLocationDataNew(lat, lang, widget.userid, user.email,newuserid);
      //  _database.reference().child("location").push().set(todo.toJson());
      FirebaseDatabase.instance
          .reference()
          .child("Recentshareddata")
          .child(newuserid)
          .set(todo.toJson());
           Navigator.pop(context);
      }
    });

  }

 
  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.reference().child("location");
    //dbRef.orderByChild("userId").equalTo(widget.userid).once();
    return Scaffold(
        appBar: AppBar(
          title: Text('List'),
          actions: <Widget>[
          new FlatButton(
              // child: new Text('List',
              //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              child: new Icon(
                Icons.share,
                color: Colors.white,
                size: 24.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: share)
        ],
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: dbRef.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    //lists.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    if (values != null)
                    {
                      lists.clear();
                    values.forEach((key, values) {
                      lists.add(values);
                    });
                    }
                    if (lists.length>0)
                    {
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  new GestureDetector(
                            //You need to make my child interactive
                            onTap: () => onClickMethod(index, lists),
                                                      child: Card(
                                                        color: (isSelected && index == selectedindex) ? Colors.blue: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Email: " + lists[index]['email']),
                                  Text("userId: " + lists[index]['userId']),
                                  Text("lat: " + lists[index]['lat'].toString()),
                                  Text(
                                      "lang: " + lists[index]['lang'].toString()),
                                ],
                              ),
                          ),
                          );
                        });
                    }
                    double height = MediaQuery.of(context).size.height;
                    return Container(height:height,
                    alignment: Alignment.center,
                    child: Text('List is Empty'));
                  }
                  return CircularProgressIndicator();
                })));
  }
  void onClickMethod(int index, List lists) {
    //String userid = lists[index];
    if (isSelected  )
    {
      if (index != selectedindex)
      {
      isSelected = true;
      }
      else{
        isSelected = false;
      }
    }
    else
    {
      isSelected = true;
    }
    selectedindex  = index;
    setState(() {
      
    });
  }
}