import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonapp_client/presentation/authentication%20screens/components/signup_textediting_controllers.dart';
import 'package:salonapp_client/presentation/authentication%20screens/repository/create_account_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import '../../../helpers/url constants/url_constants.dart';
import '../components/auth_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../repository/data model/user_model.dart';
import '../repository/user_helper.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final _auth = FirebaseAuth.instance;
  File? _image;
  bool isLoading = false;
  String imageUrl = '';
  late UserHelper userhelper;
  late AccountHelper accountHelper;

  AuthBloc() : super(AuthInitial()) {
    on<AppStartedEvent>(onAppStarted);
    on<PickImageEvent>(pickImage);
    on<SignupEvent>(registerUser);
    on<LoginEvent>(loginUser);
    on<ForgotPasswordEvent>(resetPassword);
    on<LogoutEvent>(logoutUser);
    on<LoginWithGoogleEvent>(loginWithGoogle);
  }

  Future<void> onAppStarted(
      AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');
    debugPrint('Token retrieved on app start: $token');

    if (token != null && token.isNotEmpty) {
      debugPrint('User is logged in with token: $token');

      if (!emit.isDone) {
        emit(AuthenticatedState(message: 'Signup Succesful!!'));
      }
    } else {
      debugPrint('No token found, navigating to login.');
      if (!emit.isDone) {
        emit(UnAuthenticatedState());
      }
    }
  }

  Future<void> pickImage(PickImageEvent event, Emitter<AuthState> emit) async {
    emit(ImageLoadingState());
    debugPrint("Image Loading......");

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        emit(ImagePickSuccesState(imgUrl: _image));
      } else {
        emit(ImagePickFailureState(error: 'No image was selected'));
      }
    } catch (e) {
      ImagePickFailureState(error: e.toString());
      debugPrint("Error: $e");
    }
  }

  Future<AuthClient> getAuthClient() async {
    final serviceAccount =
        await rootBundle.loadString('assets/service-account.json');
    final credentials =
        ServiceAccountCredentials.fromJson(json.decode(serviceAccount));

    final client = await clientViaServiceAccount(
      credentials,
      [drive.DriveApi.driveFileScope], // Grants access to upload files
    );

    return client;
  }

  Future<String?> uploadImageToGoogleDrive(File? imageFile) async {
    final client = await getAuthClient();
    final driveApi = drive.DriveApi(client);

    var fileMetadata = drive.File();
    fileMetadata.name = imageFile!.path.split('/').last;
    fileMetadata.parents = [
      "your-folder-id"
    ]; // Replace with your Drive folder ID

    var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

    var response =
        await driveApi.files.create(fileMetadata, uploadMedia: media);
    client.close(); // Close the client after use

    if (response.id != null) {
      print("Uploaded File ID: ${response.id}");
      return response.id; // Return the file ID
    } else {
      print("Upload failed");
      return null;
    }
  }

  Future<void> makeFilePublic(String fileId) async {
    final client = await getAuthClient();
    final driveApi = drive.DriveApi(client);

    var permission = drive.Permission();
    permission.type = "anyone";
    permission.role = "reader";

    await driveApi.permissions.create(permission, fileId);
    print("File is now public.");
    client.close();
  }

  String getPublicImageUrl(String fileId) {
    return "https://drive.google.com/uc?id=$fileId";
  }

/*
  Future<String?> uploadImageToGoogleDrive(
      File? imageFile, String accessToken) async {
    if (imageFile == null) return null;

    var url =
        "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart";
    var metadata = {
      "name": imageFile.path.split('/').last,
      "parents": ["your-folder-id"] // Optional: Change folder ID
    };

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = "Bearer $accessToken"
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['id']; // Return File ID
    } else {
      print("Failed to upload: ${response.statusCode}");
      return null;
    }
  }

  Future<void> makeFilePublic(String fileId, String accessToken) async {
    var url = "https://www.googleapis.com/drive/v3/files/$fileId/permissions";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode({"role": "reader", "type": "anyone"}),
    );

    if (response.statusCode == 200) {
      print("File made public.");
    } else {
      print("Failed to make public: ${response.statusCode}");
    }
  }

  String getPublicImageUrl(String fileId) {
    return "https://drive.google.com/uc?id=$fileId";
  }
*/
  Future<void> registerUser(SignupEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (_image != null) {
        String? fileId = await uploadImageToGoogleDrive(_image!);
        if (fileId != null) {
          await makeFilePublic(fileId);
          imageUrl = getPublicImageUrl(fileId);
        }
      }
      final user = UserModel(
        id: UserHelper.firebaseUser!.uid,
        fullname: event.fullName,
        email: event.email,
        phone: event.phone,
        password: event.password,
        profilePhoto: imageUrl ?? '',
      );

      await AccountHelper.createUser(user);

      emit(AuthenticatedState(message: 'Account Created Successfully!!'));
      debugPrint('Account Created Successfully!!');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _auth.currentUser!.uid);

      debugPrint('Auth token saved locally.');
      debugPrint('User data saved: ${_auth.currentUser!.uid}');
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

      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(AuthenticatedState(message: 'Login Succesful!!'));
      debugPrint('Login Succesful!!');
    } on FirebaseAuthException catch (error) {
      final exception = SignUpWithEmailAndPasswordFailure(error.code);
      emit(AuthFailureState(errorMessage: exception.message));
      debugPrint("Firebase auth exception ${exception.message}");
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
      debugPrint('Error:${e.toString()}');
    }
  }

  Future<void> resetPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {}

  Future<void> logoutUser(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      await _auth.signOut();
      await GoogleSignIn().signOut();

      emit(AuthLogoutSuccesState(message: 'User Logged out Succesfuly!!'));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      debugPrint('User Logged out Succesfuly!!');
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

  Future<UserCredential> loginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      emit(AuthLoadingState());
      final auth = await FirebaseAuth.instance.signInWithCredential(credential);
      emit(AuthenticatedState(message: 'Login Succesful'));
      debugPrint('Login Succesful');
      return auth;
    } on FirebaseAuthException catch (error) {
      final ex = Exception(error.code);
      emit(AuthFailureState(errorMessage: ex.toString()));
      debugPrint('Error: $ex');
      throw ex;
    } catch (_) {
      const excep = FirebaseAuthException;
      emit(AuthFailureState(errorMessage: excep.toString()));
      debugPrint('Exception $excep');
      throw excep;
    }
  }
}
