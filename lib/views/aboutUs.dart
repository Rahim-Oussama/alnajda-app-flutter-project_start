import 'package:alnajda_app/size_configs.dart';
import 'package:alnajda_app/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
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
          "About Our App",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              height: sizeV * 30,
              child: Image.asset(
                'assets/images/LogoApp.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Welcome to ALNAJDA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Created by: ',
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Text(
              '                     Rahim Oussama \n Saidani Mouhammed Salah Elddine',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // RaisedButton(
            //   onPressed: () {
            //     // Add any action you want to perform here
            //   },
            //   child: Text('Learn More'),
            // ),
          ],
        ),
      ),
    );
  }
}
