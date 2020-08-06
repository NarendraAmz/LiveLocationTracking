import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/maproute.dart';
import 'package:flutter_maps/models/todo.dart';
import 'package:flutter_maps/polysharemap.dart';
import 'package:flutter_maps/sharemap.dart';

class PolyMySharedListPage extends StatefulWidget {
  PolyMySharedListPage({Key key, this.userid}) : super(key: key);
  final String userid;

  @override
  _PolyMySharedListPageState createState() => _PolyMySharedListPageState();
}

class _PolyMySharedListPageState extends State<PolyMySharedListPage> {
  List lists;
   Query dbRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lists = new List();
         dbRef = FirebaseDatabase.instance.reference().child("polyshareddata");
  }

  @override
  Widget build(BuildContext context) {

    //dbRef.orderByChild("userId").equalTo(widget.userid).once();
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Poly Shared List'),
        //   actions: <Widget>[
        //   new FlatButton(
        //       // child: new Text('List',
        //       //     style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        //       child: new Icon(
        //         Icons.map,
        //         color: Colors.white,
        //         size: 24.0,
        //         // semanticLabel: 'Text to announce in accessibility modes',
        //       ),
        //       onPressed: maproute)
        // ],
        // ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: dbRef.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    //lists.clear();
                    
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    if(values != null)
                    {
                      lists.clear();
                    values.forEach((key, value) {
                      lists.add(key);
                    });
                    }
                    if (lists.length >0)
                    {
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new GestureDetector(
                            //You need to make my child interactive
                            onTap: () => onClickMethod(index, lists),
                            child: Card(
                              child: Column(
                                //var value = lists[index];

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                 // Text("Email: " + lists[index]['email']),
                                  Text("userId: " + lists[index]),
                                  //  Text(
                                  //      "lat: " + lists[index]['lat'].toString()),
                                  // Text("lang: " +
                                  //     lists[index]['lang'].toString()),
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
maproute() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RouteMapView()),
    );
  }
  void onClickMethod(int index, List lists) {
    String userid = lists[index];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PolyshareMapSample(
                userId: userid,
              )),
    );
  }
}
