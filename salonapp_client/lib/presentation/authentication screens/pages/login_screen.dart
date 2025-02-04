import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberme = false;
  bool isSignupScreen = true;
  bool isSigninScreen = false;
  bool isChecked = false;
  bool isLoading = false;
  bool isToggeled = true;
  bool isVisible = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                "Sign in",
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
                    SizedBox(
                      width: 280,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Sign in with your email and password or continue with your social media account",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            // controller: controller.emailController,
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
                            // controller: controller.passwordController,
                            obscureText: isVisible,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Enter Password';
                            //   } else if (controller
                            //           .passwordController.text.length <
                            //       6) {
                            //     return 'Password should be at least 6 characters ';
                            //   }
                            //   return null;
                            // },
                            decoration: InputDecoration(
                              label: const Text("password"),
                              labelStyle: const TextStyle(fontSize: 13),
                              prefixIcon: const Icon(MingCute.lock_fill),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                  setState(() {});
                                },
                                child: !isVisible
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
                      onTap: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot password? ",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            // await LoginController.instance.loginUser(
                            //   controller.emailController.text.trim(),
                            //   controller.passwordController.text.trim(),
                            // );
                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = !isLoading;
                            });
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isLoading
                              ? primaryColor.withOpacity(0.4)
                              : primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 55,
                        width: double.infinity,
                        child: Center(
                          child: isLoading
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Loading....",
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
                                  "Login",
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
                      onTap: () {
                        //  AuthenticationRepository.instance.signInWithGoogle();
                      },
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
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Register now",
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
  }
}
