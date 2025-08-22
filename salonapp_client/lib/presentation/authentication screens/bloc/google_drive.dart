import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveHelper {
  // File? _image;
  bool isLoading = false;
  String imageUrl = '';

  // Future<void> pickImage(PickImageEvent event, Emitter<AuthState> emit) async {
  //   emit(ImageLoadingState());
  //   debugPrint("Image Loading......");
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       emit(ImagePickSuccesState(imgUrl: _image));
  //     } else {
  //       emit(ImagePickFailureState(error: 'No image was selected'));
  //     }
  //   } catch (e) {
  //     ImagePickFailureState(error: e.toString());
  //     debugPrint("Error: $e");
  //   }
  // }

  Future<AuthClient> getAuthClient() async {
    final serviceAccount = await rootBundle.loadString(
        'assets/animations/formidable-bank-325022-43d02766ad7a.json');
    final credentials =
        ServiceAccountCredentials.fromJson(json.decode(serviceAccount));

    final client = await clientViaServiceAccount(
      credentials,
      [drive.DriveApi.driveFileScope],
    );

    return client;
  }

  Future<String?> uploadImageToGoogleDrive(File? imageFile) async {
    final client = await getAuthClient();
    final driveApi = drive.DriveApi(client);

    var fileMetadata = drive.File();
    fileMetadata.name = imageFile!.path.split('/').last;
    fileMetadata.parents = ["1s7GvjUetBcrdoo0qHffuRRAQDshjiU3n"];

    var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

    var response =
        await driveApi.files.create(fileMetadata, uploadMedia: media);
    client.close();

    if (response.id != null) {
      print("Uploaded File ID: ${response.id}");
      return response.id;
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
}
