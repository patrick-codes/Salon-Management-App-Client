import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/presentation/shops/bloc/shops_bloc.dart';
import 'package:salonapp_client/presentation/shops/pages/shop%20info/shops.dart';
import '../profile screen/pages/profile_page.dart';
import '../shops/pages/create_shopservice_page.dart';
import 'home.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  String? usernew;
  int _selectedIndex = 0;

  List<Widget> pages = [
    MyHomePage(),
    CreateShopPage(),
    // MapDirectionScreen(
    //   cordinates: LatLng(0, 0),
    // ),
    ShopsPage(),
    //CreateShopPage(),
    //AppointmentsPage(),
    Container(),
    ProfilePage(),
  ];

  int initPage = 0;
  onPageClick(index) {
    setState(() {
      initPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopsBloc>(context),
      child: Scaffold(
          backgroundColor: secondaryColor2,
          bottomNavigationBar: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: secondaryColor,
            hoverColor: Colors.orange,
            activeColor: Colors.white,
            iconSize: 25,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            duration: const Duration(milliseconds: 300),
            color: Colors.black45,
            curve: Curves.bounceIn,
            style: GnavStyle.oldSchool,
            tabBackgroundColor: backgroundColor,
            tabBorderRadius: 100.0,
            tabMargin: EdgeInsets.all(5),
            textSize: 8,
            gap: 0,
            tabs: const [
              GButton(
                icon: MingCute.home_5_line,
                text: 'Home',
              ),
              GButton(
                icon: MingCute.location_line,
                text: 'Explore',
              ),
              GButton(
                icon: MingCute.scissors_line,
                text: 'Shops',
              ),
              GButton(
                icon: MingCute.list_check_3_line,
                text: 'Bookings',
              ),
              GButton(
                icon: MingCute.user_1_line,
                text: 'Profile',
              ),
            ],
          ),
          body: pages.elementAt(_selectedIndex)),
    );
  }
}
