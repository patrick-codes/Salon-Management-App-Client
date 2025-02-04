import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salonapp_client/presentation/shops/shop%20info/shop_info.dart';
import 'helpers/colors/color_constants.dart';
import 'presentation/authentication screens/pages/login_screen.dart';
import 'presentation/authentication screens/pages/signup_screen.dart';
import 'presentation/home/home.dart';
import 'presentation/home/main_home.dart';
import 'presentation/intro screens/pages/splash_screen.dart';
import 'presentation/intro screens/pages/welcome_screen.dart';
import 'presentation/shops/pages/main_shop_page.dart';

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
