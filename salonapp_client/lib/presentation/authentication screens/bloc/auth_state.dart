// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final String message;

  AuthenticatedState({required this.message});
}

class UnAuthenticatedState extends AuthState {}

class AuthFailureState extends AuthState {
  final String errorMessage;

  AuthFailureState({required this.errorMessage});
}

class AuthLogoutSuccesState extends AuthState {
  final String message;

  AuthLogoutSuccesState({
    required this.message,
  });
}

class ImageLoadingState extends AuthState {}

class ImagePickSuccesState extends AuthState {
  final File? imgUrl;

  ImagePickSuccesState({required this.imgUrl});
}

class ImageUrlSuccesState extends AuthState {
  final String? imgUrl;

  ImageUrlSuccesState({required this.imgUrl});
}

class ImagePickFailureState extends AuthState {
  final String error;

  ImagePickFailureState({required this.error});
}

class AuthLogoutFailureState extends AuthState {
  final String error;

  AuthLogoutFailureState({required this.error});
}

class PasswordResetSuccesState extends AuthState {}

class PasswordResetFailureState extends AuthState {}

class UserLoadingState extends AuthState {}

class CurrentUserState extends AuthState {
  final UserModel? user;

  CurrentUserState(this.user);
}

class UserLoadingFailState extends AuthState {
  final String error;

  UserLoadingFailState(this.error);
}
