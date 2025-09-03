import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SmsService {
  final Dio dio = Dio();

  Future<void> sendSmsNotification({
    required String appId,
    required String name,
    required DateTime dateTime,
    required String phone,
  }) async {
    try {
      // format datetime into readable string
      final formattedDateTime = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);

      final response = await dio.post(
        "https://block-yard-backend.onrender.com/api/sms/send",
        data: {
          "appid": appId,
          "name": name,
          "dateTime": formattedDateTime,
          "phone": phone,
        },
      );

      if (response.statusCode == 200) {
        print("SMS sent successfully!");
      } else {
        print("Failed to send SMS: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      print("Error sending SMS: $e");
    }
  }

  /// Send SMS to shop owner
  Future<void> sendOwnerSms({
    required String appId,
    required String name,
    required DateTime dateTime,
    required String? phone,
  }) async {
    try {
      final formattedDateTime = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);

      final response = await dio.post(
        "https://block-yard-backend.onrender.com/api/sms/send/owner",
        data: {
          "appid": appId,
          "name": name,
          "dateTime": formattedDateTime,
          "phone": phone,
        },
      );
      print("Owner SMS Response: ${response.data}");
    } catch (e) {
      print("Error sending Owner SMS: $e");
    }
  }
}
