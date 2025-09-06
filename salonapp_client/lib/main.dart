import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/salonapp_observer.dart';
import 'firebase_options.dart';
import 'salonapp_blocs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> ownernavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Bloc.observer = const SalonappObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Firebase Connected Succesfuly");

  runApp(const SalonAppBlocs());
}
