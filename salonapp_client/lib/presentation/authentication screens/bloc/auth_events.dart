// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEvents {}

class AppStartedEvent extends AuthEvents {}

class SignupEvent extends AuthEvents {
  String fullName;
  String gender;
  // final String dob;
  // final String profileImgUrl;
  String phone;
  // final List locationCordinates;
  String email;
  String password;

  SignupEvent({
    //required this.locationCordinates,
    required this.fullName,
    required this.gender,
    required this.phone,
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

class PickImageEvent extends AuthEvents {}

class CurrentUserEvent extends AuthEvents {
  final String? userId; // make it nullable
  CurrentUserEvent({this.userId});
}
