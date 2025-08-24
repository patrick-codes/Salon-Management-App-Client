import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

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
      listener: (context, state) {
        if (state is AuthLogoutSuccesState) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
        if (state is AuthLogoutFailureState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0.5,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(8),
                content: Text(state.error),
                backgroundColor: blackColor,
              ),
            );
          });
        }
        if (state is UserLoadingState) {
          Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        if (state is CurrentUserState) {
          if (state.user != null) {
            user = state.user;
            debugPrint("User loaded: ${state.user!.fullname}");
          } else {
            debugPrint("Received CurrentUserState but userData is null");
          }
        }

        return Scaffold(
          backgroundColor: whiteColor,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.center,
                        //   end: Alignment.bottomCenter,
                        //   colors: [
                        //     Colors.grey.withOpacity(0.95),
                        //     whiteColor,
                        //   ],
                        // ),
                        ),
                    child: Stack(children: [
                      Positioned(
                        bottom: 20,
                        top: 200,
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
                                            border: Border.all(
                                                color: outlineGrey, width: 4),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: user?.profilePhoto !=
                                                          null &&
                                                      user!.profilePhoto!
                                                          .isNotEmpty
                                                  ? NetworkImage(
                                                      user!.profilePhoto!)
                                                  : const AssetImage(
                                                          "assets/images/logo.jpg")
                                                      as ImageProvider,
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
                                              color: blackColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                MingCute.camera_line,
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
                                user?.createdAt != null
                                    ? 'Member since ${DateFormat.yMMMMd().format(user!.createdAt!)}'
                                    : 'Member since -',
                                size: 12,
                                color: Colors.black45,
                              ),
                              SizedBox(height: 15),
                              GestureDetector(
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
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: subheadingText(
                                      context,
                                      'Logout',
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
                ),
                Divider(color: primaryContainerShade),
              ],
            ),
          ),
        );
      },
    );
  }
}
