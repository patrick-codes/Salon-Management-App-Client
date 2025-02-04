part of 'auth_bloc.dart';

sealed class AuthEvents {}

class AppStartedEvent extends AuthEvents {}

class SignupEvents extends AuthEvents {}

class LoginEvent extends AuthEvents {}

class LogoutEvent extends AuthEvents {}
