// ignore_for_file: deprecated_member_use, unused_import

import 'package:alnajda_app/datahandler/appData.dart';
import 'package:alnajda_app/views/aboutUs.dart';
import 'package:alnajda_app/views/home-screen.dart';
import 'package:alnajda_app/views/mainscreen.dart';
import 'package:alnajda_app/views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alnajda_app/model/onboard_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './views/pages.dart';
import 'package:provider/provider.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //to show status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //to load on board screen for first time
  SharedPreferences pref = await SharedPreferences.getInstance();
  seenOnboard = pref.getBool('seenOnboard') ?? false; //if null set to false
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ALNAJDA',
        theme: ThemeData(
          textTheme: GoogleFonts.manropeTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/sign-in': (context) => SignUp(),
          '/profil': (context) => ProfileScreen(),
          '/aboutUs': (context) => AboutUs(),
        },
        home: seenOnboard == true ? SignUp() : OnBoardingPage(),
      ),
    );
  }
}
