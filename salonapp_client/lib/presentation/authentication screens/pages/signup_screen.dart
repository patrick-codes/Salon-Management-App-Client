import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/presentation/authentication%20screens/bloc/auth_bloc.dart';
import 'package:toastification/toastification.dart';
import '../components/signup_textediting_controllers.dart';

class SignupScren extends StatefulWidget {
  const SignupScren({super.key});

  @override
  State<SignupScren> createState() => _SignupScrenState();
}

class _SignupScrenState extends State<SignupScren> {
  bool isRememberme = false;
  bool isSignupScreen = true;
  bool isSigninScreen = false;
  bool isChecked = false;
  bool isLoading = false;
  bool isToggeled = true;
  bool isVisible = true;
  File? image;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthFailureState) {
          toastification.show(
            showProgressBar: false,
            description: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  state.errorMessage,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ],
            ),
            autoCloseDuration: const Duration(seconds: 7),
            style: ToastificationStyle.minimal,
            type: ToastificationType.error,
          );
        } else if (state is AuthenticatedState) {
          Navigator.pushReplacementNamed(context, '/mainhome');
          toastification.show(
            showProgressBar: false,
            description: Column(
              children: [
                Text(
                  state.message,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ],
            ),
            autoCloseDuration: const Duration(seconds: 7),
            style: ToastificationStyle.minimal,
            type: ToastificationType.success,
          );
        } else if (state is ImagePickSuccesState) {
          image = state.imgUrl;
        }
      },
      builder: (BuildContext context, AuthState state) {
        return Scaffold(
          backgroundColor: secondaryColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
            leading: const Icon(
              MingCute.arrow_left_fill,
              color: primaryColor,
            ),
            foregroundColor: primaryColor,
            surfaceTintColor: primaryColor,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        // SizedBox(
                        //   width: 280,
                        //   child: Center(
                        //     child: Text(
                        //       textAlign: TextAlign.center,
                        //       "Create an account with your email and password or continue with your social media account",
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .bodySmall!
                        //           .copyWith(
                        //             color: Colors.black87,
                        //             fontSize: 15,
                        //           ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 18),
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                context.read<AuthBloc>().add(PickImageEvent()),
                            child: Stack(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3,
                                    ),
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
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: primaryColor,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        MingCute.camera_fill,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: SignupController.fullname,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    print('Enter Username');
                                    return 'Enter Username';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("username"),
                                  labelStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(MingCute.user_2_fill),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  isDense: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: SignupController.contact,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    print('Enter Contact');
                                    return 'Enter Contact';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("contact"),
                                  labelStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(MingCute.phone_fill),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  isDense: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: SignupController.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    print('Enter Email');
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("email"),
                                  labelStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(MingCute.mail_fill),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  isDense: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: SignupController.password,
                                obscureText: false,
                                // isVisible,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Password';
                                  } else if (SignupController
                                          .password.text.length <
                                      6) {
                                    return 'Password should be at least 6 characters ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("password"),
                                  labelStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(MingCute.lock_fill),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   isVisible = !isVisible;
                                      // });
                                      // setState(() {});
                                    },
                                    child: isVisible
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              final _fullName =
                                  SignupController.fullname.text.trim();
                              final _gender =
                                  SignupController.gender.text.trim();
                              final _phone =
                                  SignupController.contact.text.trim();

                              final _email = SignupController.email.text.trim();
                              final _password =
                                  SignupController.password.text.trim();
                              context.read<AuthBloc>().add(
                                    SignupEvent(
                                      fullName: _fullName,
                                      gender: _gender,
                                      phone: _phone,
                                      email: _email,
                                      password: _password,
                                    ),
                                  );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: state is AuthLoadingState
                                  ? primaryColor.withOpacity(0.4)
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 55,
                            width: double.infinity,
                            child: Center(
                              child: state is AuthLoadingState
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Creating Account....",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          height: 17,
                                          width: 17,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          // onTap: () {
                          //   Navigator.pushNamed(context, '/mainhome');
                          // },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: primaryColor,
                              ),
                              //color: ColorConstants.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Row(
                                  children: [
                                    const Text(
                                      "Login with ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Brand(Brands.google, size: 20),
                                    const Text(
                                      "oogle",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already Registered? ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Login now",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
