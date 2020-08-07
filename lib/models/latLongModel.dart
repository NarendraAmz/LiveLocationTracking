// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_maps/main.dart';

class LatListmodel{
  String user;
  List<Map<String,dynamic>> listData;

   LatListmodel({
    this.user,
    this.listData
  });
  LatListmodel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? json['user'] : '';
    listData = json['listData'] != null ? json['listData'] : null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['user'] = user;
    map['listData'] = listData;
    return map;
  }
}
class LatLongmodel {
  double latitude;
  double longitude;
  String userName;
  String datetime;

  LatLongmodel({
    this.latitude,
    this.longitude,
    this.userName,
    this.datetime
  });
  LatLongmodel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] != null ? json['latitude'] : '';
    longitude = json['longitude'] != null ? json['longitude'] : '';
    userName = json['user'] != null ? json['user'] : '';
    datetime = json['date'] != null ? json['date'] : '';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['user'] = userName;
    map['date'] = datetime;
    return map;
  }
}

// class DataRepository {
//   // 1
//   final CollectionReference collection = Firestore.instance.collection('RecentPlaceslist');
//   // 2
//   Stream<QuerySnapshot> getStream() {
//     return collection.snapshots();
//   }
//   // 3
//   Future<dynamic> addName(LatListmodel data) {
//     print(data);
//     // return collection.add(data.toMap());
//     // return Firestore.instance.collection('RecentPlaceslist').document().updateData(data.toMap());
//     // List<Map<String,dynamic>> mainArray = [];

//     // for(var i = 0; i< data.listData.length ; i++)
//     // {  
//     //   LatLongmodel modelData = new LatLongmodel();
//     //   print('${data.listData[i].latitude}');
//     //    modelData.latitude = data.listData[i].latitude;
//     //    modelData.longitude = data.listData[i].longitude;
//     //    modelData.userName= data.listData[i].userName;
//     //    mainArray.add(modelData.toMap());
//     // }
//     return collection.add(data.toMap());
//   }
 
// }