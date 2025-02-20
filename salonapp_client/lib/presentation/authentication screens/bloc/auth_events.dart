part of 'auth_bloc.dart';

sealed class AuthEvents {}

class AppStartedEvent extends AuthEvents {}

class SignupEvent extends AuthEvents {
  // final String fullName;
  // final String gender;
  // final String dob;
  // final String profileImgUrl;
//  final String phone;
  // final List locationCordinates;
  final String email;
  final String password;

  SignupEvent({
    // required this.fullName,
    // required this.gender,
    // required this.dob,
    // required this.profileImgUrl,
    // required this.phone,
    // required this.locationCordinates,
    required this.email,
    required this.password,
  });
}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class LoginWithGoogleEvent extends AuthEvents {}

class LogoutEvent extends AuthEvents {}

class ForgotPasswordEvent extends AuthEvents {}
