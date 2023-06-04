import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Icon(
            Icons.arrow_circle_right,
            size: 30,
            color: Color(0xff573353),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text("AlNajda",
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Klasik',
                )),
          ),
          Spacer(),
          Badge(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "profile");
              },
            ),
          ),
        ],
      ),
    );
  }
}
