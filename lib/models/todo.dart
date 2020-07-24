import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String subject;
  bool completed;
  String userId;

  Todo(this.subject, this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    subject = snapshot.value["subject"],
    completed = snapshot.value["completed"];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}

class LocationDataNew {
  double lat;
  double lang;
  String key;
  String userId;

  LocationDataNew(this.lat, this.lang,this.userId);

  LocationDataNew.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    lat = snapshot.value["lat"],
    lang = snapshot.value["lang"];
    

  toJson() {
    return {
      "userId": userId,
      "lat": lat,
      "lang": lang,
      
    };
  }
}