import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';

import '../helpers/colors/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.scissors_line,
      //color: primaryColor,
    ),
    const Icon(
      MingCute.hair_line,
      //color: primaryColor,
    ),
    const Icon(
      MingCute.sob_fill,
      //color: primaryColor,
    ),
    const Icon(
      MingCute.brush_line,
      //color: primaryColor,
    ),
    const Icon(
      MingCute.hair_line,
      //color: primaryColor,
    ),
    const Icon(
      MingCute.sob_fill,
      //color: primaryColor,
    ),
  ];

  List<String> title = <String>[
    "Haircuts",
    "Shaves",
    "Dyeing",
    "Shampoo",
    "Locking",
    "Natural",
  ];

  List<String> gender = <String>[
    "Woman",
    "Man",
    "Other",
  ];

  List<String> price = <String>[
    "GHC 20",
    "GHC 30",
    "GHC 50",
  ];

  bool isStars = true;

  int selectedIndex = -1;

  double textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Filter",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                MinimalHeadingText(leftText: "Services", rightText: ''),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: icons.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCategoryCircle(
                          context, icons[index], title[index]);
                    },
                  ),
                ),
                // const SizedBox(height: 25),
                // MinimalHeadingText(leftText: "Rating", rightText: ''),
                // const SizedBox(height: 8),
                // Row(
                //   children: [
                //     for (int i = 0; i < 5; i++)
                //       Icon(
                //         MingCute.star_fill,
                //         color: primaryColor,
                //         size: 18,
                //       ),
                //     SizedBox(width: 15),
                //   ],
                // ),
                const SizedBox(height: 25),
                MinimalHeadingText(leftText: "Gender", rightText: ''),
                SizedBox(height: 8),
                SizedBox(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: gender.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return buildSquareGenderButton(
                          context,
                          gender[index],
                          index == 1 ? Colors.white : Colors.transparent,
                          index == 1 ? primaryColor : Colors.grey.shade300,
                          index == 1 ? primaryColor : Colors.black54);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                MinimalHeadingText(leftText: "Distance", rightText: ''),
                SizedBox(height: 8),
                SizedBox(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              allowedInteraction: SliderInteraction.slideThumb,
                              value: textSize,
                              min: 12,
                              max: 24,
                              thumbColor: primaryColor,
                              activeColor: primaryColor,
                              //divisions: 12,
                              label: textSize.toStringAsFixed(0),
                              onChanged: (value) {
                                setState(() {
                                  textSize = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            "${textSize.toInt()} km",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MinimalHeadingText(leftText: "Price", rightText: ''),
                SizedBox(height: 8),
                SizedBox(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: gender.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return buildSquarePriceButton(
                          context,
                          price[index],
                          index == 1 ? Colors.white : Colors.transparent,
                          index == 1 ? primaryColor : Colors.grey.shade300,
                          index == 1 ? primaryColor : Colors.black54);
                    },
                  ),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    text: 'Apply Filters (5)',
                    onpressed: () {},
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryCircle(BuildContext context, Icon icon, String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Colors.black12,
            ),
            // color: tertiaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget buildSquareGenderButton(BuildContext context, String title,
      Color bgcolor, Color brcolor, Color textcolor) {
    return Container(
      height: 30,
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgcolor,
        border: Border.all(
          width: 1.5,
          color: brcolor,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: textcolor,
                fontSize: 11,
              ),
        ),
      ),
    );
  }

  Widget buildSquarePriceButton(BuildContext context, String title,
      Color bgcolor, Color brcolor, Color textcolor) {
    return Container(
      height: 30,
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgcolor,
        border: Border.all(
          width: 1.5,
          color: brcolor,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: textcolor,
                fontSize: 11,
              ),
        ),
      ),
    );
  }
}
