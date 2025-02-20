import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/custom_button.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';

import '../../../helpers/colors/color_constants.dart';

class ShopInfo extends StatefulWidget {
  const ShopInfo({super.key});

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.message_4_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.phone_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.location_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.share_2_line,
      color: primaryColor,
    ),
  ];
  List<String> title = <String>[
    "Message",
    "Call",
    "Direction",
    "Share",
  ];
  List<String> names = <String>[
    "Patrick",
    "Boateng",
    "Agyemang",
    "Agyenim",
    "Agyabeng",
    "Christiana",
  ];
  List<String> locations = <String>[
    "Gbawe",
    "Weija",
    "Bortianor",
    "Dansoman",
    "Odorkor",
    "Mallam",
  ];

  List<String> imgs = <String>[
    "assets/images/img-one.jpg",
    "assets/images/img-two.jpg",
    "assets/images/img-three.jpg",
    "assets/images/img-one.jpg",
    "assets/images/img-two.jpg",
    "assets/images/img-three.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: secondaryColor2,
          appBar: AppBar(
            centerTitle: true,
            leading: const Icon(
              MingCute.arrow_left_fill,
              color: Colors.white,
            ),
            title: Text(
              "Details",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            actions: [
              Icon(
                MingCute.more_2_fill,
                color: Colors.white,
              ),
              SizedBox(width: 8),
            ],
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.40,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/img6.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 270,
          child: SizedBox(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              overflow: TextOverflow.visible,
                              'Captain Barbershop ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Close",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                MingCute.location_fill,
                                size: 13,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                'Lafa Street, Gbawe-Accra',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                MingCute.star_fill,
                                size: 13,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                overflow: TextOverflow.visible,
                                '4.8(3,279 reviews)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCategorySquare(
                                icons[index], title[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 15),
                      MinimalHeadingText(
                          leftText: "Our Specialist", rightText: "See all"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 125,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: imgs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return buildSpecialistSquare(
                                imgs[index], names[index], locations[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
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
                  onpressed: () {},
                  color: primaryColor,
                ),
              ),
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
          height: 60,
          width: 60,
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget buildSpecialistSquare(String imgurl, String title, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 85,
          width: 85,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.grey.shade200,
            ),
          ),
          child: Center(
            child: CircleAvatar(
              backgroundImage: Image.asset(imgurl).image,
              radius: 30,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.black54,
                  ),
            ),
            SizedBox(height: 3),
            Row(
              children: [
                const Icon(
                  MingCute.location_fill,
                  size: 11,
                  color: primaryColor,
                ),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.black45,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
