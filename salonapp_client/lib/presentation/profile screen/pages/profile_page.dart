import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../helpers/colors/color_constants.dart';
import '../../../helpers/widgets/text_widgets.dart';
import '../../authentication screens/bloc/auth_bloc.dart';
import '../../authentication screens/repository/data model/user_model.dart';
import '../../checkout page/components/Transaction/other/show_up_animation.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? image;
  UserModel? user;
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        if (state is AuthLogoutSuccesState) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
        if (state is CurrentUserState) {
          user = state.user;
          debugPrint("User loaded: ${user!.fullname}");
        }
      },
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoadingState) {
          debugPrint('Logging out....!!');
        }
        if (state is AuthLogoutFailureState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0.5,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(8),
                content: Text(
                  state.error,
                  style: const TextStyle(),
                ),
                backgroundColor: blackColor,
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: whiteColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 295,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.95),
                        whiteColor,
                      ],
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      bottom: 5,
                      top: -180,
                      right: -50,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 200,
                        color: whiteColor.withOpacity(0.05),
                      ),
                    ),
                    Positioned(
                      bottom: -190,
                      top: 5,
                      left: -50,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 280,
                        color: whiteColor.withOpacity(0.05),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      top: 20,
                      right: 20,
                      left: 20,
                      child: ShowUpAnimation(
                        delay: 200,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
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
                                                        "assets/images/logo.jpg")
                                                    .image,
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        left: 80,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: secondaryColor4,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              MingCute.camera_line,
                                              color: primaryColor,
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
                            SizedBox(height: 18),
                            headingTextMedium(
                              context,
                              user?.fullname ?? 'username',
                              FontWeight.w600,
                              23,
                              blackColor,
                            ),
                            subheadingText(
                              context,
                              'Member since 2025',
                              size: 12,
                              color: Colors.black45,
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 30,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: subheadingText(
                                    context,
                                    'Profile',
                                    size: 12.5,
                                    color: whiteColor,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Divider(color: primaryContainerShade),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8.0),
                                    bottom: Radius.circular(8),
                                  ),
                                ),
                                title: Center(
                                  child: headingTextMedium(
                                    context,
                                    'Confirm Action',
                                    FontWeight.bold,
                                    16,
                                  ),
                                ),
                                content: headingTextMedium(
                                  context,
                                  'Are you sure you want to log out?',
                                  FontWeight.w500,
                                  12,
                                ),
                                actions: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(LogoutEvent());
                                    },
                                    child: headingTextMedium(
                                      context,
                                      'Confirm',
                                      FontWeight.w600,
                                      12,
                                      iconGrey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: headingTextMedium(
                                      context,
                                      'Cancel',
                                      FontWeight.w600,
                                      12,
                                      Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        dense: true,
                        horizontalTitleGap: 12,
                        minVerticalPadding: 2,
                        minTileHeight: 5,
                        contentPadding: EdgeInsets.symmetric(),
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              MingCute.exit_line,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                        title: headingTextMedium(
                          context,
                          "Logout",
                          FontWeight.w500,
                          13,
                          blackColor,
                        ),
                        subtitle: subheadingTextMedium(
                          context,
                          'Logout your account',
                          11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
