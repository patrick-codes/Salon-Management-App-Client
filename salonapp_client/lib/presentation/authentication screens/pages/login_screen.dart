import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:toastification/toastification.dart';

import '../../checkout page/components/Transaction/other/show_up_animation.dart';
import '../bloc/auth_bloc.dart';
import '../components/signup_textediting_controllers.dart';

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
        }
      },
      builder: (BuildContext context, state) {
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
                    child: ShowUpAnimation(
                      delay: 150,
                      child: Column(
                        children: [
                          const SizedBox(height: 18),
                          SizedBox(
                            width: 280,
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "Sign in with your email and password or continue with your social media account",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
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
                                  obscureText: isVisible,
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
                                final _email =
                                    SignupController.email.text.trim();
                                final _password =
                                    SignupController.password.text.trim();
                                context.read<AuthBloc>().add(
                                      LoginEvent(
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
                                            "Logging in....",
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
                          const SizedBox(height: 50),
                          Divider(
                            color: Colors.grey.shade400,
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
