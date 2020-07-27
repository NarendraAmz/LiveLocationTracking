import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/models/todo.dart';
import 'package:flutter_maps/sharemap.dart';


class MySharedListPage extends StatefulWidget {
  MySharedListPage({Key key, this.userid}) : super(key: key);
  final String userid;

  @override
  _MySharedListPageState createState() => _MySharedListPageState();
}
class _MySharedListPageState extends State<MySharedListPage> {
  List lists;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      lists = new List();
  }
  @override
  Widget build(BuildContext context) {
       final dbRef = FirebaseDatabase.instance.reference().child("shareddata");
   //dbRef.orderByChild("userId").equalTo(widget.userid).once();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared List'),
      ),
      body: 
         SingleChildScrollView(child: 
        FutureBuilder(
    future: dbRef.once(),
    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
        //lists.clear();
        Map<dynamic, dynamic> values = snapshot.data.value;
        values.forEach((key, values) {
            lists.add(values);
        });
        return new ListView.builder(
            shrinkWrap: true,
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
              //You need to make my child interactive
              onTap: () => onClickMethod(index, lists),
                                  child: Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text("Email: " + lists[index]['email']),
                      Text("userId: " + lists[index]['userId']),
                      Text("lat: "+ lists[index]['lat'].toString()),
                      Text("lang: " +lists[index]['lang'].toString()),
                      ],
                  ),
                  ),
                );
                
            });
        }
        return CircularProgressIndicator();
    })
        )
      
    );
  }
  void onClickMethod(int index,List lists)
  {
    String userid = lists[index]['userId'];
       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SharemapPage(userId: userid,user: null,value: false,)),
  );
  }

}
