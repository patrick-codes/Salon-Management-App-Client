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

class AuthLoggedoutState extends AuthState {
  final String message;

  AuthLoggedoutState({required this.message});
}
