

import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  String uid;
  DatabaseService(this.uid);

  final DatabaseReference users = FirebaseDatabase.instance.reference();

  //creates a document for the rider in the database during signUp
  Future createUser(
      {name, number, email, url, isNumberVerified, provider}) async {
    return await users.child('riders').child(uid).set({
      'name': name,
      'number': number ?? '',
      'isNumberVerified': isNumberVerified,
      'provider': provider,
      'email': email,
      'pictureURL': url ?? '',
    });
  }
}