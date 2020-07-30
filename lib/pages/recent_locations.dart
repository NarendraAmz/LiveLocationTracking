import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/CommonComponent/listComponent.dart';
import 'package:flutter_maps/main.dart';
import 'package:flutter_maps/models/latLongModel.dart';

class RecentLocationComponenet extends StatefulWidget {
  RecentLocationComponenet({Key key, this.userid}) : super(key: key);
  final String userid;
  @override
  RecentLocationState createState() => RecentLocationState();
}

class RecentLocationState extends State<RecentLocationComponenet> {
  final DataRepository repository = DataRepository();
//  List<LatListmodel> _dataList = [];
  LatListmodel mainModel = new LatListmodel();
  List _listViewData = [];
  List<LatLongmodel> latLongmodel = [];
  LatLongmodel model = new LatLongmodel();

  @override
  void initState() {
    super.initState();
  }

 getDataList(Map<dynamic,dynamic> mainData) {
   
     dynamic data = mainData;
     if (data != null) {
      if (widget.userid == data['user']) {
        mainModel.user = data['user'];
        List<dynamic> listData = data['listData'];
        List<Map<String,dynamic>> mainSubData = [];
        for(var i = 0;i<listData.length ; i++)
        {
          mainSubData.add({'latitude':listData[i]['latitude'],'longitude':listData[i]['longitude'],'user':listData[i]['user'],'date':listData[i]['date']});
        }
        mainModel.listData = mainSubData;
      }
      if (mainModel != null) {
        getmainData(mainModel);
      }
    }
    
  }
 getmainData(LatListmodel data) {
    if (data.user != null) {
      if (data.user == widget.userid) {
        if (data.listData != null) {
          List<LatLongmodel> latdatamodel = [];
          for (var i = 0; i < data.listData.length; i++) {
            LatLongmodel datamodel = new LatLongmodel();
            datamodel.latitude = data.listData[i]['latitude'];
            datamodel.longitude = data.listData[i]['longitude'];
            datamodel.userName = data.listData[i]['user'];
            datamodel.datetime = data.listData[i]['date'];
    
              latdatamodel.add(datamodel);
        
          }
          latLongmodel = latdatamodel;
        } else {
          latLongmodel = [];
        }
      } else {
        latLongmodel = [];
      }
    } else {
      latLongmodel = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbRef =
        FirebaseDatabase.instance.reference().child("RecentPlaceslist").child(widget.userid);
    return Scaffold(
        appBar: AppBar(
          title: Text('Recent Places'),
        ),
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                //lists.clear();
                Map<dynamic, dynamic> valueData = snapshot.data.value;
                getDataList(valueData);
                if (valueData != null) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: new Text(
                    'User : ',
                    // 'Account number',
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  )),
              new Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: new Text(
                    mainModel.user != null ? '${mainModel.user}' : '',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ))
            ],
          ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListClass(
                          height: MediaQuery.of(context).size.height/1.3,
                          errorMessage: 'no data available',
                          datalistArray: latLongmodel,
                          subChild: (index) {
                            return subChild(index);
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  latLongmodel = [];
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Text('No Data Available'),
                    alignment: Alignment.center,
                  );
                }
              }
              return Container(
                    height: MediaQuery.of(context).size.height,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
            }));
  }

  Widget subChild(int index) {
    LatLongmodel data = new LatLongmodel();
    data = latLongmodel[index];
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  )),
              new Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: new Text(
                    '${data.latitude}',
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
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
                    'Long',
                    // 'Account number',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  )),
              new Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: new Text(
                    '${data.latitude}',
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
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
                    'Date',
                    // 'Account number',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  )),
              new Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: new Text(
                    '${data.datetime}',
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ))
            ],
          )
        ]));
  }
}
