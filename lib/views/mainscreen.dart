import 'dart:async';
import 'package:alnajda_app/Assistants/assistantMethod.dart';
import 'package:alnajda_app/Assistants/geoFireAssistant.dart';
import 'package:alnajda_app/configMaps.dart';
import 'package:alnajda_app/datahandler/appData.dart';
import 'package:alnajda_app/models/nearbyAvailableDrivers.dart';
import 'package:alnajda_app/views/searchScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Assistants/sendNotificationToDriver.dart';
import '../datahandler/get_lat_long_address.dart';
import '../widgets/divider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late String username;

  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  double? lat;

  double? long;

  double requestRideContainerHeight = 0;
  double rideDetailsContainerHeight = 300;

  bool draweropen = true;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  bool nearbyAvailableDriverKeysLoaded = false;

  late BitmapDescriptor nearByIcon;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    currentPosition = position;
    LatLng latLagPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLagPosition, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String Address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address ::  $Address");

    initGeoFireListner();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late DatabaseReference rideRequestRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;

    Map<String, String> pickUpLocMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo?.username,
      "rider_phone": userCurrentInfo?.phone,
      "pickup_address": pickUp.placeName,
    };

    rideRequestRef.set(rideInfoMap);

    String driverFCMToken = 'DRIVER_FCM_TOKEN';

    // Send the notification to the driver's app
    sendNotificationToDriver(driverFCMToken);
  }

  void cancelRideRequest() {
    rideRequestRef.remove();
  }

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      draweropen = true;
    });

    saveRideRequest();
  }

  resetApp() {
    setState(() {
      draweropen = true;
      rideDetailsContainerHeight = 300;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedButtonIndex = -1;
    final myColor1 = Color(0xff573353);
    final myColor2 = Color(0xFFFC9D45);
    const colorizeTextStyle = TextStyle(
        fontSize: 40.0, fontFamily: 'klasik', fontWeight: FontWeight.normal);
    const colorizeColors = [
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    //createIconMarker();
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: Text("Main Screen"),
      // ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/profile.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userCurrentInfo?.username ?? "Username",
                            style: TextStyle(
                              fontFamily: 'Klasik',
                              color: myColor1,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text("Good Morning "),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              DeviderWidget(),

              SizedBox(
                height: 12.0,
              ),
              //drawer Body controllers

              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "History",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/profil',
                    (route) => false,
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/aboutUs',
                    (route) => false,
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/sign-in',
                    (route) => false,
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    "Sign out",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();

              setState(() {
                bottomPaddingOfMap = 300.0;
              });
            },
          ),

          //humberger Button for drawer
          Positioned(
            top: 70.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: myColor2,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          // Positioned(
          //   left: 0.0,
          //   right: 0.0,
          //   bottom: 0.0,
          //   child: Container(
          //     height: 200.0, //for search box height
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(18.0),
          //           topRight: Radius.circular(18.0)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black,
          //           blurRadius: 16.0,
          //           spreadRadius: 0.5,
          //           offset: Offset(0.7, 0.7),
          //         ),
          //       ],
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //           horizontal: 24.0, vertical: 18.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(height: 6.0),
          //           Text("Salut, ",
          //               style: TextStyle(
          //                 fontFamily: 'Klasik',
          //                 color: myColor1,
          //                 fontWeight: FontWeight.bold,
          //                 letterSpacing: 1.5,
          //                 fontSize: 16,
          //               )),
          //           Text("Ok Ou ? ",
          //               style: TextStyle(
          //                 fontFamily: 'Klasik',
          //                 color: myColor1,
          //                 //fontWeight: FontWeight.bold,
          //                 letterSpacing: 1.5,
          //                 fontSize: 20,
          //               )),
          //           SizedBox(height: 20.0),
          //           GestureDetector(
          //             onTap: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => SearchScreen()));
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(5.0),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black54,
          //                     blurRadius: 6.0,
          //                     spreadRadius: 0.5,
          //                     offset: Offset(0.7, 0.7),
          //                   ),
          //                 ],
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(12.0),
          //                 child: Row(
          //                   children: [
          //                     Icon(
          //                       Icons.search,
          //                       color: myColor2,
          //                     ),
          //                     SizedBox(width: 10.0),
          //                     Text("Rechercher un lieu"),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 24.0,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              // vsync :this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: myColor2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(children: [
                            Image.asset("assets/images/towing-vehicle.png",
                                height: 70.0, width: 80.0),
                            SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Car Service",
                                  style: TextStyle(
                                      fontSize: 16.0, fontFamily: 'Klasik'),
                                ),
                                Text(
                                  "need help!",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                      fontFamily: 'Klasik'),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedButtonIndex = 0;
                                });
                              },
                              child: Container(
                                width: 100.0,
                                height: 50,
                                color: selectedButtonIndex == 0
                                    ? Colors.blue
                                    : Colors.black54,
                                child: Center(
                                  child: Text(
                                    'Towing',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedButtonIndex = 1;
                                });
                              },
                              child: Container(
                                width: 100.0,
                                height: 50,
                                color: selectedButtonIndex == 1
                                    ? Colors.blue
                                    : Colors.black54,
                                child: Center(
                                  child: Text(
                                    'Mechanic',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedButtonIndex = 2;
                                });
                              },
                              child: Container(
                                width: 100.0,
                                height: 50,
                                color: selectedButtonIndex == 2
                                    ? Colors.blue
                                    : Colors.black54,
                                child: Center(
                                  child: Text(
                                    'Electric',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {
                              displayRequestRideContainer();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  myColor1), // Set the desired color
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Klasik',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.truck,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 260),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16.0,
                      color: Colors.black54,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: requestRideContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              "Request for a roadside assistance...",
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                            ColorizeAnimatedText(
                              "Please, wait ...",
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                            ColorizeAnimatedText(
                              "Searching for assistance...",
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRideRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            color: myColor2,
                            borderRadius: BorderRadius.circular(26.0),
                            border: Border.all(width: 2.0, color: myColor1),
                          ),
                          child: Icon(
                            Icons.close,
                            color: myColor1,
                            size: 26.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel the service request",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Marker pickUpLocMarker = Marker(
  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
  //   //infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my location"),
  //   //position: pickUpLatLong,
  //   markerId: MarkerId("pickUpId"),
  // );

  void initGeoFireListner() {
    Geofire.initialize("availableDrivers");
    //comment
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude,
            10) // the 10 means that will display drivers in 10 km
        ?.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
                    latitude: currentPosition.latitude,
                    longitude: currentPosition.longitude);
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearbyAvailableDrivers);
            if (nearbyAvailableDriverKeysLoaded == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
                    latitude: currentPosition.latitude,
                    longitude: currentPosition.longitude);
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
    //comment
  }

  void updateAvailableDriversOnMap() {
    Set<Marker> tMarkers = Set<Marker>();
    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvailablePosition =
          LatLng(driver.latitude, driver.longitude);
      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvailablePosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        rotation: AssistantMethods.createRandomNumber(360),
      );

      tMarkers.add(marker);
    }

    setState(() {
      markersSet = tMarkers;
    });
  }

  // void createIconMarker() async {
  //   if (nearByIcon == null) {
  //     ImageConfiguration imageConfiguration =
  //         createLocalImageConfiguration(context, size: Size(2, 2));
  //     BitmapDescriptor.fromAssetImage(
  //             imageConfiguration, "assets/images/driver_loc.png")
  //         .then((value) {
  //       nearByIcon = value;
  //     });
  //   }
  // }
}
