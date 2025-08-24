import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ExternalAppLauncher {
  static Uri? googleMapsUri;
  static Uri? whatsappUri;
  static Uri? phoneUri;
  static Uri? downloadUri;

  static Future<void> downloadLink() async {
    downloadUri = Uri.parse(
        "https://drive.google.com/drive/u/3/folders/1v5kclO6Q7XqZue5L5vi73kZgpFpewTYx");

    if (await canLaunchUrl(downloadUri!)) {
      await launchUrl(downloadUri!, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Download Link';
    }
  }

  static Future<void> openGoogleMaps(List<double?> cordinates) async {
    googleMapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$cordinates");

    if (await canLaunchUrl(googleMapsUri!)) {
      await launchUrl(googleMapsUri!, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  static Future<void> openWhatsApp(String? phoneNumber, String? message) async {
    whatsappUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message!)}");

    if (await canLaunchUrl(whatsappUri!)) {
      await launchUrl(whatsappUri!, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  static Future<void> launchPhoneCall(String? phoneNumber) async {
    phoneUri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrl(phoneUri!)) {
      await launchUrl(phoneUri!);
    } else {
      throw 'Could not launch Phone call';
    }
  }

  static Future<void> shareContent(String? content) async {
    await Share.share(content!);
  }
}
