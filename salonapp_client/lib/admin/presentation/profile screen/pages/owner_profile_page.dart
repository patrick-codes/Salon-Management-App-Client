import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toastification/toastification.dart';
import '../../../../presentation/authentication screens/bloc/auth_bloc.dart';
import '../../../helpers/constants/color_constants.dart';
import '../../../helpers/text style/text_style.dart';
import '../../../helpers/widgets/dialog_util.dart';
import '../../../helpers/widgets/show_up_animation.dart';

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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        if (state is AuthLogoutSuccesState) {
          Navigator.pushNamed(context, '/login');
          toastification.show(
            showProgressBar: false,
            description: Column(
              children: [
                Text(
                  state.message,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            autoCloseDuration: const Duration(seconds: 7),
            style: ToastificationStyle.fillColored,
            type: ToastificationType.info,
          );
        } else if (state is AuthLogoutFailureState) {
          toastification.show(
            showProgressBar: true,
            description: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  state.error,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            autoCloseDuration: const Duration(seconds: 7),
            style: ToastificationStyle.fillColored,
            type: ToastificationType.error,
          );
        }
      },
      builder: (BuildContext context, state) {
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
                        child: itemContainer(
                          index,
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
      },
    );
  }

  Widget itemContainer(
    int index,
    BuildContext context,
    String text,
    Icon icon,
  ) {
    return GestureDetector(
      onTap: () {
        if (index == 5) {
          showDialog(
            context: context,
            builder: (context) => DialogBoxUtil(
              context,
              onTap: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
              content: 'Confirm Logout',
              leftText: 'Cancel',
              rightText: 'Logout',
              oncancel: () {
                Navigator.pop(context);
              },
              icon: Icons.logout_outlined,
            ),
          );
        }
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
