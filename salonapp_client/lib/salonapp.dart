import 'package:flutter/material.dart';
import 'package:salonapp_client/presentation/shops/pages/shop%20info/shop_info.dart';
import 'helpers/colors/color_constants.dart';
import 'presentation/appointments/pages/appointments_page.dart';
import 'presentation/appointments/pages/receipt_page.dart';
import 'presentation/authentication screens/pages/login_screen.dart';
import 'presentation/authentication screens/pages/signup_screen.dart';
import 'presentation/home/home.dart';
import 'presentation/home/main_home.dart';
import 'presentation/intro screens/pages/splash_screen.dart';
import 'presentation/intro screens/pages/welcome_screen.dart';
import 'presentation/shops/components/map_directions_screen.dart';
import 'presentation/shops/pages/main_shop_page.dart';
import 'package:toastification/toastification.dart';
import 'presentation/shops/pages/shop info/shops.dart';

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hairvana',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScren(),
          '/main': (context) => const MyHomePage(),
          '/mainhome': (context) => const MainHomePage(),
          '/shopinfo': (context) => const ShopInfo(),
          '/shops': (context) => ShopsPage(),
          '/appointments': (context) => AppointmentsPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/mainshopinfo') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MainShopinfoPage(id: args['id']),
            );
          }
          if (settings.name == '/map') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MapDirectionScreen(
                cordinates: args['latlng'],
              ),
            );
          }
          if (settings.name == '/receipt') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ReceiptPage(
                id: args['id'],
              ),
            );
          }
          return null;
        },
        theme: ThemeData(
          fontFamily: 'Poppins',
          // textTheme: GoogleFonts.interTextTheme(
          //   Theme.of(context).textTheme,
          // ),
          scaffoldBackgroundColor: primaryBg,
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
      ),
    );
  }
}
