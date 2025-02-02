import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salonapp_client/presentation/authentication%20screens/login_screen.dart';
import 'package:salonapp_client/presentation/authentication%20screens/signup_screen.dart';
import 'package:salonapp_client/presentation/checkout%20page/checkout_page.dart';
import 'package:salonapp_client/presentation/intro%20screens/welcome_screen.dart';
import 'package:salonapp_client/presentation/shops/shop%20info/shop_info.dart';
import 'package:salonapp_client/presentation/shops/main_shop_page.dart';
import 'helpers/colors/color_constants.dart';
import 'presentation/home/home.dart';
import 'presentation/home/main_home.dart';
import 'presentation/intro screens/splash_screen.dart';

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hairvana',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScren(),
        '/main': (context) => const MyHomePage(),
        '/mainhome': (context) => const MainHomePage(),
        '/shopinfo': (context) => const ShopInfo(),
        '/mainshopinfo': (context) => const MainShopinfoPage(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
