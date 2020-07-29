import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/models/todo.dart';

class MyListPage extends StatefulWidget {
  MyListPage({Key key, this.userid}) : super(key: key);
  final String userid;

  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  List lists;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lists = new List();
  }

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.reference().child("location");
    //dbRef.orderByChild("userId").equalTo(widget.userid).once();
    return Scaffold(
        appBar: AppBar(
          title: Text('List'),
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
                          return Card(
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
}
