class OnBoarding {
  final String title;
  final String image;

  OnBoarding({
    required this.title,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Bienvenu dans \n AlNajda',
    image: 'assets/images/firstpic.png',
  ),
  OnBoarding(
    title: "Améloirer l'operation de depannage",
    image: 'assets/images/secondpic.png',
  ),
  OnBoarding(
    title: 'Economiser le temps',
    image: 'assets/images/thirdpic.png',
  ),
  OnBoarding(
    title: 'Rejoignez une communaute de soutien',
    image: 'assets/images/fourthpic.png',
  ),
];
