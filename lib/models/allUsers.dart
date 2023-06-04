import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  late String? id;
  late String? phone;
  late String? username;

  Users(
      //{this.id, this.phone, this.username}
      );

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    phone = (dataSnapshot.value as Map<dynamic, dynamic>)['phone']?.toString();
    username =
        (dataSnapshot.value as Map<dynamic, dynamic>)['username']?.toString();
  }
}
