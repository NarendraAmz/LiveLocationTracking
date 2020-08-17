import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String subject;
  bool completed;
  String userId;

  Todo(this.subject, this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
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
  String email;

  LocationDataNew(this.lat, this.lang, this.userId, this.email);

  LocationDataNew.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        email = snapshot.value["email"],
        lat = snapshot.value["lat"],
        lang = snapshot.value["lang"];

  toJson() {
    return {"userId": userId, "lat": lat, "lang": lang, "email": email};
  }
}
class RecentLocationDataNew {
  double lat;
  double lang;
  String key;
  String userId;
  String email;
  String shareduserId;
  

  RecentLocationDataNew(this.lat, this.lang, this.userId, this.email,this.shareduserId);

  RecentLocationDataNew.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
         shareduserId = snapshot.value["shareduserId"],
        email = snapshot.value["email"],
        lat = snapshot.value["lat"],
        lang = snapshot.value["lang"];


  toJson() {
    return {"userId": userId, "lat": lat, "lang": lang, "email": email, 
    "shareduserId": shareduserId};
  }
}
