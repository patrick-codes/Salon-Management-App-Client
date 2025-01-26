// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/presentation/appointments/appointments_page.dart';
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
    AppointmentsPage(),
    Container(),
    Container(),
    Container(),
  ];

  int initPage = 0;
  onPageClick(index) {
    setState(() {
      initPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
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
              icon: MingCute.map_line,
              text: 'Explore',
            ),
            GButton(
              icon: MingCute.scissors_line,
              text: 'Shops',
            ),
            GButton(
              icon: MingCute.chat_1_line,
              text: 'Message',
            ),
            GButton(
              icon: MingCute.user_1_line,
              text: 'Profile',
            ),
          ],
        ),
        body: pages.elementAt(_selectedIndex));
  }
}
