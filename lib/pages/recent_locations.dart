import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/CommonComponent/listComponent.dart';
import 'package:flutter_maps/models/latLongModel.dart';



class RecentLocationComponenet extends StatefulWidget {
   RecentLocationComponenet({Key key, this.userid}) : super(key: key);
  final String userid;
  @override
  RecentLocationState createState() => RecentLocationState();
}
class RecentLocationState extends State<RecentLocationComponenet> {
 final DataRepository repository = DataRepository();
 List<LatListmodel> _dataList = [];
 LatListmodel mainModel = new LatListmodel();
static final List<Map<String,dynamic>> _listViewData = [
    {'key':'lavanya'},
    {'key':'narendra'},
    {'key':'venkatesh'}
  ];

  @override
  void initState() {
    super.initState();
  
  }
  getDataList(AsyncSnapshot<QuerySnapshot> snapshot){
     _dataList = [];
     for(var i = 0;i < snapshot.data.documents.length ; i++)
     {
         getmainData(snapshot.data.documents[i]);
     }
   
  }
  getmainData(DocumentSnapshot data)
  { 
     if(data['user'] != null)
  {
    if(data['user'] == widget.userid)
    {
         mainModel.user = data['user'];
         mainModel.listData = data['listData'];
         _dataList.add(mainModel);
    }

  }
      
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Recent Places'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (context, snapshot){
           if (!snapshot.hasData)
          {
            return Center(child: LinearProgressIndicator());
          }
          else
          {
            getDataList(snapshot);
          return Column(
           mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            SizedBox(height: 50),
            Text(mainModel.user != null ? '${mainModel.user}' : ''),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListClass(height: 500,errorMessage: 'no data available',datalistArray: mainModel.listData,subChild: (index){
                return subChild(index);
              },),
            )
          ],
        );
          }
      })
    );
  }
 
  Widget subChild(int index){
    LatLongmodel data = new LatLongmodel();
    data = mainModel.listData[index];
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
              '${data.latitude}',
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
              '${data.latitude}',
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