import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonapp_client/presentation/authentication%20screens/repository/create_account_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data repository/image uploader/cloudinary_uploader.dart';
import '../components/auth_exception.dart';
import '../repository/data model/user_model.dart';
import '../repository/user_helper.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final _auth = FirebaseAuth.instance;
  File? _image;
  bool isLoading = false;
  String imageUrl = '';

  AuthBloc() : super(AuthInitial()) {
    on<AppStartedEvent>(onAppStarted);
    on<PickImageEvent>(onPickImage);
    on<SignupEvent>(registerUser);
    on<LoginEvent>(loginUser);
    on<ForgotPasswordEvent>(resetPassword);
    on<LogoutEvent>(logoutUser);
    on<CurrentUserEvent>(currentUser);
  }

  Future<void> onAppStarted(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');
    final String? role = prefs.getString('userRole'); // 👈 restore role too

    debugPrint('Token retrieved on app start: $token');
    debugPrint('Role retrieved on app start: $role');

    if (token != null && token.isNotEmpty) {
      try {
        // Optionally fetch latest user data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(token)
            .get();

        if (doc.exists) {
          final user = UserModel.fromFirestore(doc, null);

          emit(AuthenticatedState(
            message: 'Welcome back!',
            user: user,
          ));
        } else {
          // fallback if no doc, use cached role
          emit(AuthenticatedState(
            message: 'Welcome back!',
            user: UserModel(
              id: token,
              fullname: 'Unknown',
              email: '',
              phone: '',
              password: '',
              profilePhoto: '',
              role: role ?? 'user', // 👈 default to saved role
            ),
          ));
        }
      } catch (e) {
        emit(AuthFailureState(errorMessage: e.toString()));
      }
    } else {
      emit(UnAuthenticatedState());
    }
  }

  Future<void> onPickImage(
      PickImageEvent event, Emitter<AuthState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      emit(ImagePickSuccesState(
        imgUrl: _image!,
      ));
    } else {
      emit(ImagePickFailureState(error: 'No image selected'));
    }
  }

  Future<void> registerUser(SignupEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (_image != null) {
        String? uploadedUrl = await CloudinaryHelper.uploadImage(_image!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
          emit(ImageUrlSuccesState(imgUrl: imageUrl));
          debugPrint("Image uploaded: $imageUrl");
        } else {
          emit(ImagePickFailureState(error: 'Image upload failed'));
        }
      }

      final user = UserModel(
        id: UserHelper.firebaseUser!.uid,
        fullname: event.fullName,
        email: event.email,
        phone: event.phone,
        role: event.role,
        password: event.password,
        profilePhoto: imageUrl ?? '',
      );

      await AccountHelper.createUser(user);

      emit(AuthenticatedState(
          message: 'Account Created Successfully!!', user: user));
      debugPrint('Account Created Successfully!!');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _auth.currentUser!.uid);
      await prefs.setString('userRole', event.role);

      debugPrint('AuthToken saved locally.');
      debugPrint('Role saved locally: ${event.role}');
    } on FirebaseAuthException catch (error) {
      final exception =
          SignUpWithEmailAndPasswordFailure(error.message.toString());
      emit(AuthFailureState(errorMessage: exception.message));
      debugPrint(exception.message);
    } catch (e) {
      emit(AuthFailureState(errorMessage: 'Error: ${e.toString()}'));
      debugPrint('Error:${e.toString()}');
    }
  }

  Future<void> loginUser(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      // Sign in with Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final userId = credential.user!.uid;

      // 🔎 Try to fetch user from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String role = "user"; // default
      UserModel? userModel;

      if (doc.exists) {
        final data = doc.data()!;
        role = data['role'] ?? "user";
        userModel = UserModel.fromFirestore(doc, null);
      } else {
        debugPrint("⚠️ Firestore record not found for $userId");
      }

      // Save UID + role in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', userId);
      await prefs.setString('userRole', role);

      debugPrint('AuthToken saved: $userId');
      debugPrint('Role saved: $role');

      // Emit success
      emit(AuthenticatedState(
        message: 'Login Successful!!',
        user: userModel,
      ));
    } on FirebaseAuthException catch (error) {
      final exception =
          SignUpWithEmailAndPasswordFailure(error.message ?? error.code);
      emit(AuthFailureState(errorMessage: exception.message));
      debugPrint("Firebase auth exception: ${exception.message}");
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
      debugPrint('Error: ${e.toString()}');
    }
  }

  Future<void> resetPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {}

  Future<void> logoutUser(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      await _auth.signOut();
      // //await GoogleSignIn().signOut();

      emit(AuthLogoutSuccesState(message: 'User Logged out Succesfuly!!'));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      debugPrint('User Logged out Succesfuly!!');
      debugPrint('AuthToken removed !!');
    } on FirebaseAuthException catch (e) {
      emit(AuthLogoutFailureState(error: e.message.toString()));
      debugPrint('Logout Failed:${e.message}');
      throw e.message!;
    } on FormatException catch (e) {
      emit(AuthLogoutFailureState(error: e.message));
      debugPrint('Logout Failed:${e.message}');
      throw e.message;
    } catch (e) {
      emit(AuthLogoutFailureState(error: e.toString()));
      debugPrint('Logout Failed:$e');
      throw 'Unable to Logout. Try again';
    }
  }

  Future<void> currentUser(
    CurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      final user = await UserModel.getCurrentUser(); // already fetches role too

      if (user.id != null && user.id!.isNotEmpty) {
        emit(CurrentUserState(user)); // UI can now access user.role
      } else {
        emit(UserLoadingFailState("No authenticated user found"));
      }
    } catch (e) {
      emit(UserLoadingFailState(e.toString()));
      debugPrint("Error in currentUser: $e");
    }
  }
}
