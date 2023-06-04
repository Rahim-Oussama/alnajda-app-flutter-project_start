// ignore_for_file: unused_local_variable

import 'package:alnajda_app/views/mainscreen.dart';
import 'package:alnajda_app/views/pages.dart';
import 'package:flutter/material.dart';
import 'package:alnajda_app/app_styles.dart';
import 'package:alnajda_app/main.dart';
import 'package:alnajda_app/model/onboard_data.dart';
import 'package:alnajda_app/size_configs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 400),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : kSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  // this will set seenOnboard to true when running for first time *******************************
  Future setSeenonboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seenOnboard = await prefs.setBool('seenOnboard', true);
  }
  //*********************************************************************************************

  @override
  void initState() {
    super.initState();
    setSeenonboard();
  }

  @override
  Widget build(BuildContext context) {
    //initialize size config
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    SizedBox(
                      height: sizeV * 6,
                    ),
                    Text(
                      onboardingContents[index].title,
                      style: kTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sizeV * 6,
                    ),
                    Container(
                      height: sizeV * 45,
                      child: Image.asset(
                        onboardingContents[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: sizeV * 6,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: kBodyText1,
                        children: [
                          TextSpan(
                              text: "ALNAJDA ",
                              style: TextStyle(color: kPrimaryColor)),
                          TextSpan(text: "A mobile application \n for "),
                          TextSpan(
                              text: "automotive troubleshooting",
                              style: TextStyle(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeV * 6,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  currentPage == onboardingContents.length - 1
                      ? MyTextButton(
                          buttonName: 'START',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // la page d'inscription ***********************************************
                                    builder: (context) => SignUp()));
                            //*******************************************************
                          },
                          bgColor: kPrimaryColor,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OnBoardNavBtn(
                              name: 'Skip',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                            ),
                            Row(
                              children: List.generate(onboardingContents.length,
                                  (index) => dotIndicator(index)),
                            ),
                            OnBoardNavBtn(
                              name: 'Next',
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
