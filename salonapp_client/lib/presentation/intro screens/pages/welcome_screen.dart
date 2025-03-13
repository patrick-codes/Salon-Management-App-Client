import 'package:flutter/material.dart';
import 'package:salonapp_client/helpers/colors/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../helpers/colors/color_constants.dart';
import '../../checkout page/components/Transaction/other/show_up_animation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TitleText? titleText;
  static final _controller = PageController();
  List<String> images = [
    "assets/images/logo.jpg",
    "assets/images/img.jpg",
    "assets/images/img2.jpg",
    "assets/images/img3.jpg",
    "assets/images/img4.jpg",
    "assets/images/img5.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Column(
          children: [
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: infos.length,
                effect: const ExpandingDotsEffect(
                  paintStyle: PaintingStyle.fill,
                  activeDotColor: primaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ShowUpAnimation(
                delay: 300,
                child: CustomButton(
                  text: "Get Started",
                  onpressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/img.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withOpacity(0.6),
                        backgroundColor
                      ],
                    ),
                  ),
                  child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: infos.length,
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        titleText = infos[index];
                        return SizedBox(
                          height: 130,
                          width: 90,
                          child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ShowUpAnimation(
                                    delay: 300,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: titleText!.title,
                                          ),
                                          TextSpan(
                                            text: titleText!.waitingText,
                                            style: const TextStyle(
                                              color: primaryColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: titleText!.middleText,
                                          ),
                                          TextSpan(
                                            text: titleText!.appointmentText,
                                            style: const TextStyle(
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ShowUpAnimation(
                                  delay: 300,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    titleText!.subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TitleText {
  String title;
  String subtitle;
  String waitingText;
  String middleText;
  String appointmentText;

  TitleText({
    required this.title,
    required this.subtitle,
    required this.waitingText,
    required this.middleText,
    required this.appointmentText,
  });
}

List<TitleText> infos = [
  TitleText(
    title: "Say Goodbye ",
    subtitle:
        "Delivers messages faster than any other application The world's fastest messaging app. It is free and secure.",
    waitingText: "to Waiting ",
    middleText: "The Fastest Way to Book your BarberShop ",
    appointmentText: "Appointment",
  ),
  TitleText(
    title: "Say Goodbye ",
    subtitle:
        "Delivers messages faster than any other application The world's fastest messaging app. It is free and secure.",
    waitingText: "to Waiting ",
    middleText: "The Fastest Way to Book your BarberShop ",
    appointmentText: "Appointment",
  ),
  TitleText(
    title: "Say Goodbye ",
    subtitle:
        "Delivers messages faster than any other application The world's fastest messaging app. It is free and secure.",
    waitingText: "to Waiting ",
    middleText: "The Fastest Way to Book your BarberShop ",
    appointmentText: "Appointment",
  ),
];
