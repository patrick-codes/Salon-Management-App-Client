import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../helpers/url constants/url_constants.dart';

class CloudinaryHelper {
  static Future<String?> uploadImage(File imageFile) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      return data["secure_url"]; // Cloudinary CDN URL
    } else {
      print("❌ Upload failed: $resBody");
      return null;
    }
  }
}
