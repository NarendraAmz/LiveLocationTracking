import 'package:cloud_firestore/cloud_firestore.dart';

class LatListmodel{
  String user;
  List<LatLongmodel> listData;

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

  LatLongmodel({
    this.latitude,
    this.longitude,
    this.userName
  });
  LatLongmodel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] != null ? json['latitude'] : '';
    longitude = json['longitude'] != null ? json['longitude'] : '';
    userName = json['user'] != null ? json['user'] : '';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['user'] = userName;
    return map;
  }
}

class DataRepository {
  // 1
  final CollectionReference collection = Firestore.instance.collection('RecentPlaceslist');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addName(LatListmodel data) {
    return collection.add(data.toMap());
  }
 
}