class OnboardingData {
  final String text;
  final String image;
  OnboardingData({required this.text, required this.image});
}

List<OnboardingData> splashData = [
  OnboardingData(
    text: "Welcome to Miloo, Let’s shop!",
    image: "assets/images/onboarding1.svg",
  ),
  OnboardingData(
    text: "We help students to buy and sell cheaply",
    image: "assets/images/onboarding2.svg",
  ),
  OnboardingData(
    text: "We show the easy way to shop. \nJust stay at home with us",
    image: "assets/images/onboarding3.svg",
  ),
];
