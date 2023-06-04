// ignore_for_file: duplicate_import, unused_import

import 'dart:async';
import 'dart:math';

import 'package:alnajda_app/Assistants/requestAssistant.dart';
import 'package:alnajda_app/datahandler/appData.dart';
import 'package:alnajda_app/models/allUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:alnajda_app/models/address.dart';
import 'package:provider/provider.dart';
import '../configMaps.dart';
import '../models/address.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    // ignore: unused_local_variable
    var index = 0;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    //var response = await RequestAssistant.getRequest(url);
    if (
        //response != 'failed'
        true) {
      if (placeAddress != "failed") {
        placeAddress = "${position.longitude},${position.latitude},";
      }
      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.altitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String? userId = firebaseUser?.uid;
    if (userId != null) {
      DatabaseReference reference =
          FirebaseDatabase.instance.reference().child("users").child(userId);
      reference.once().then((DatabaseEvent event) {
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          userCurrentInfo = Users.fromSnapshot(dataSnapshot);
        }
      });
    }
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }
}
