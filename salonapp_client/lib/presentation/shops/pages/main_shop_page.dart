import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';

import '../../../helpers/colors/color_constants.dart';
import '../../../helpers/colors/widgets/custom_button.dart';
import '../../../helpers/colors/widgets/minimal_heading.dart';
import '../../checkout page/pages/checkout_page.dart';

class MainShopinfoPage extends StatefulWidget {
  const MainShopinfoPage({super.key});

  @override
  State<MainShopinfoPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<MainShopinfoPage> {
  List<String> imgs = <String>[
    "assets/images/img-sixteen.jpg",
    "assets/images/img-ten.jpg",
    "assets/images/img-seventeen.jpg",
    "assets/images/img4.jpeg",
    "assets/images/img5.jpg",
    "assets/images/img-thirteen.jpg",
  ];
  List<String> services = <String>[
    "Shaving and Shapping",
    "Beard Trim",
    "Cut & Dye",
    "Color Dye",
    "Sporting Haircut Guys",
    "Sporting Haircut Ladies",
  ];
  List<String> prices = <String>[
    "GHC 20",
    "GHC 30",
    "GHC 25",
    "GHC 40",
    "GHC 45",
    "GHC 50",
  ];
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.whatsapp_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.phone_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.location_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.share_2_line,
      color: primaryColor,
      size: 30,
    ),
  ];
  List<String> title = <String>[
    "WhatsApp",
    "Call",
    "Direction",
    "Share",
  ];
  bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(
          MingCute.arrow_left_fill,
          color: Colors.white,
        ),
        actions: [
          Container(
            height: 25,
            width: 70,
            decoration: BoxDecoration(
              color: isOpen == false ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                isOpen == false ? "CLOSED" : "OPENED",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        height: 90,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey.shade100,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: CustomButton(
              text: "Book Now",
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CheckoutPage(
                      title: 'Captain Salon Captain',
                      quantity: 20,
                      amount: 30,
                      img: 'assets/images/img-sixteen.jpg',
                    ),
                  ),
                );
              },
              color: primaryColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              //padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage("assets/images/img3.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 137,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide.none),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withOpacity(0.2),
                            backgroundColor
                          ],
                        ),
                        color: backgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Captain Barbershop Captain Captain",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.25,
                                        color: Colors.white,
                                      ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          MingCute.calendar_2_fill,
                                          size: 20,
                                          color: primaryColor,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          'Opening Days: Monday - Saturday',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          MingCute.clock_2_fill,
                                          size: 20,
                                          color: primaryColor,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          '8am - 10pm',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          MingCute.location_fill,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          "GBAWE - ACCRA",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          MingCute.route_fill,
                                          size: 20,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          "5KM AWAY",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 85,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: icons.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return buildCategorySquare(icons[index], title[index]);
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: MinimalHeadingText(
                leftText: 'What service we provide',
                rightText: 'View all',
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: imgs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return buildServicesSquare(
                    imgs[index],
                    services[index],
                    prices[index],
                    index == 1 ? primaryColor : Colors.grey.shade200,
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: MinimalHeadingText(
                leftText: 'Our latest works',
                rightText: 'View all',
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: imgs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return buildLatestWorksSquare(
                      imgs[index], services[index], prices[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServicesSquare(
      String imgurl, String services, String prices, Color brColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 125,
          width: 115,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: brColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      MingCute.scissors_fill,
                      size: 20,
                    ),
                    PrimaryText(
                      text: prices,
                      size: 15,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    )
                  ],
                ),
                SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLatestWorksSquare(String imgurl, String title, String prices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 115,
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(imgurl).image,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.grey.shade200,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategorySquare(Icon icons, String title) {
    return Column(
      children: [
        Container(
          height: 63,
          width: 63,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: tertiaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: icons,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: iconGrey,
              ),
        ),
      ],
    );
  }
}
