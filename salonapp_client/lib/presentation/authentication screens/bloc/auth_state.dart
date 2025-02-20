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

class AuthLogoutFailureState extends AuthState {
  final String error;

  AuthLogoutFailureState({required this.error});
}

class PasswordResetSuccesState extends AuthState {}

class PasswordResetFailureState extends AuthState {}
