import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/CommonComponent/listComponent.dart';



class RecentLocationComponenet extends StatefulWidget {
   RecentLocationComponenet({Key key, this.userid}) : super(key: key);
  final String userid;
  @override
  RecentLocationState createState() => RecentLocationState();
}
class RecentLocationState extends State<RecentLocationComponenet> {
 
static final List<Map<String,dynamic>> _listViewData = [
    {'key':'lavanya'},
    {'key':'narendra'},
    {'key':'venkatesh'}
  ];

  @override
  void initState() {
    super.initState();
  
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Recent Places'),),
      body: 
      Column(
           mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            SizedBox(height: 50),
            Text('${widget.userid}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListClass(height: 500,errorMessage: 'no data available',datalistArray: _listViewData,subChild: (index){
                return subChild(index);
              },),
            )
          ],
        ),
    );
  }
 
  Widget subChild(int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.only(left: 30),
            child: new Text(
              'Lat',
              // 'Account number',
              style: new TextStyle(
                  fontSize: 16.0,
                  color:  Colors.grey[400],
                  fontWeight: FontWeight.normal,),
              textAlign: TextAlign.start,
            )),
        new Padding(
            padding: EdgeInsets.only(right: 30),
            child: new Text(
              '090990678',
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,),
              textAlign: TextAlign.start,
            ))
      ],
    ),
     new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.only(left: 30),
            child: new Text(
              'Lng',
              // 'Account number',
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.normal,),
              textAlign: TextAlign.start,
            )),
        new Padding(
            padding: EdgeInsets.only(right: 30),
            child: new Text(
              '09822989282',
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,),
              textAlign: TextAlign.start,
            ))
      ],
    )
          ])
    );
  }


}