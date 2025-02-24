import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../helpers/colors/color_constants.dart';

class ShopsPage extends StatefulWidget {
  ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  List<String> imgs = <String>[
    "assets/images/img8.jpg",
    "assets/images/img.jpg",
    "assets/images/img3.jpg",
    "assets/images/img5.jpg",
    "assets/images/img9.jpg",
    "assets/images/img6.jpg",
  ];
  bool isFavClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(124),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: primaryColor,
                  statusBarIconBrightness: Brightness.light,
                ),
                backgroundColor: Colors.transparent,
                leading: const Icon(
                  MingCute.arrow_left_fill,
                ),
                centerTitle: true,
                title: Text(
                  "Shops",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      MingCute.more_2_fill,
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                decoration: InputDecoration(
                  hintText: "Search....",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(MingCute.search_3_line, color: Colors.grey),
                  suffixIcon: const SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(MingCute.close_line, color: Colors.grey),
                        SizedBox(width: 10),
                        Icon(MingCute.list_search_line, color: Colors.grey),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  isDense: true,
                  fillColor: tertiaryColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 270,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: imgs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return appointmentContainer(context, imgs[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container appointmentContainer(BuildContext context, String imgurl) {
    return Container(
      height: 320,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(imgurl),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide.none),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  backgroundColor.withOpacity(0.2),
                                  backgroundColor
                                ]),
                            color: backgroundColor,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  MingCute.location_fill,
                                  size: 20,
                                  color: primaryColor,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Lafa Street, Gbawe-Accra',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          'Captain Barbershop Captain',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    wordSpacing: 2,
                                    //color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  MingCute.calendar_2_fill,
                                  size: 15,
                                  color: primaryColor,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Opening Days: Monday - Saturday',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  MingCute.clock_2_fill,
                                  size: 15,
                                  color: primaryColor,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  '8am - 10pm',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          overflow: TextOverflow.visible,
                          'Services:',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          overflow: TextOverflow.visible,
                          'Undercut Haircut, Regular Shaving, Natural Hair Wash, Regular Shaving,',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavClicked = !isFavClicked;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(8),
                                    content: Text(
                                      isFavClicked == false
                                          ? "Shop added to favorites!!"
                                          : "Shop removed from favorites",
                                      style: const TextStyle(),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 69, 66, 65),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isFavClicked == true
                                          ? Icon(
                                              MingCute.heart_line,
                                              size: 15,
                                              color: Colors.black45,
                                            )
                                          : Icon(
                                              MingCute.heart_fill,
                                              size: 15,
                                              color: Colors.red,
                                            ),
                                      SizedBox(width: 3),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        isFavClicked == true
                                            ? 'Add to favorite'
                                            : 'Favorite',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/mainshopinfo');
                              },
                              child: Container(
                                height: 30,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "Book an appointment",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
