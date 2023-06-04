import 'package:flutter/cupertino.dart';
import 'package:alnajda_app/models/address.dart';

class AppData extends ChangeNotifier {
  late Address pickUpLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
