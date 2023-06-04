// ignore_for_file: camel_case_types

import 'package:alnajda_app/configMaps.dart';
import 'package:alnajda_app/views/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                ),
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Colors.black54,
            )),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 20),
            itemProfile(
              'Username',
              userCurrentInfo?.username ?? "profile Username",
              CupertinoIcons.person,
            ),
            const SizedBox(height: 10),
            itemProfile(
              'Phone Number',
              userCurrentInfo?.phone ?? '+213',
              CupertinoIcons.phone,
            ),
            const SizedBox(height: 10),
            itemProfile(
              'Address',
              'BBA, Algeria',
              CupertinoIcons.location,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFC9D45),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Klasik',
                    color: Color(0xff573353),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5),
              color: Color(0xFFFC9D45).withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 10)
        ]),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(iconData),
      trailing:
          Icon(Icons.arrow_forward, color: Color.fromARGB(255, 255, 255, 255)),
      tileColor: Colors.white,
    ),
  );
}
