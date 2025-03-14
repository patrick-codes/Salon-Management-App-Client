import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import '../../../helpers/colors/color_constants.dart';
import '../../checkout page/components/Transaction/other/show_up_animation.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  File? image;
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.user_4_line,
      color: blackColor,
    ),
    const Icon(
      MingCute.package_line,
      color: blackColor,
    ),
    const Icon(
      MingCute.card_pay_line,
      color: blackColor,
    ),
    const Icon(
      MingCute.bookmark_line,
      color: blackColor,
    ),
    const Icon(
      MingCute.notification_line,
      color: blackColor,
    ),
    const Icon(
      MingCute.exit_line,
      color: blackColor,
    ),
  ];
  List<String> title = <String>[
    "Profile",
    "Our Packages",
    "Payment Method",
    "My Bookmarks",
    "Notifications",
    "Log out",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          const SizedBox(height: 60),
          ShowUpAnimation(
            delay: 300,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                //  context.read<AuthBloc>().add(PickImageEvent()),
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: image != null
                              ? Image.file(image!).image
                              : Image.asset(
                                      fit: BoxFit.fitHeight,
                                      height: 120,
                                      width: 120,
                                      "assets/images/userImage.png")
                                  .image,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 80,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: primaryColor2,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Icon(
                            MingCute.edit_4_line,
                            color: whiteColor,
                            size: 16,
                          ),
                        ),
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
            child: PrimaryText(
              text: "Flint Banaman",
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
          ShowUpAnimation(
            delay: 300,
            child: PrimaryText(
              text: "(+233) 2455 13607",
              color: iconGrey,
              size: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: icons.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return ShowUpAnimation(
                    delay: 300,
                    child: shopContainer(
                      context,
                      title[index],
                      icons[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shopContainer(
    BuildContext context,
    String text,
    Icon icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/shopinfo');
      },
      child: Container(
        height: 45,
        margin: const EdgeInsets.symmetric(vertical: 6),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor2,
          border: Border.all(
            width: 0.6,
            color: secondaryColor,
          ),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon,
                    SizedBox(width: 5),
                    PrimaryText(
                      size: 12,
                      text: text,
                      color: blackColor,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: blackColor,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
