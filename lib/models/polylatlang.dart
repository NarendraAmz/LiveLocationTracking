class PolyLatListmodel{
  String user;
  List<Map<String,dynamic>> listData;

   PolyLatListmodel({
    this.user,
    this.listData
  });
  PolyLatListmodel.fromJson(Map<String, dynamic> json) {
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


class PolyLatLongmodel {
  double latitude;
  double longitude;
  

  PolyLatLongmodel({
    this.latitude,
    this.longitude,
  });
  PolyLatLongmodel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] != null ? json['latitude'] : '';
    longitude = json['longitude'] != null ? json['longitude'] : '';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}