import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';

import '../filter screen/pages/filter_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.scissors_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.hair_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.sob_fill,
      color: primaryColor,
    ),
    const Icon(
      MingCute.brush_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.hair_line,
      color: primaryColor,
    ),
    const Icon(
      MingCute.sob_fill,
      color: primaryColor,
    ),
  ];
  List<String> title = <String>[
    "Haircuts",
    "Shaves",
    "Dyeing",
    "Shampoo",
    "Locking",
    "Natural",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300]!.withOpacity(0.28),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome Back,",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Center(
                            child: Icon(
                              MingCute.notification_line,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Let's Find                                       ",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                          ),
                          TextSpan(
                            text: "your top Barber!",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        scrollBottomSheet(context);
                      },
                      // controller: controller.emailController,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          print('Type something');
                          return 'Type something';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                        prefixIcon: const Icon(
                          MingCute.search_2_line,
                          color: Colors.grey,
                          size: 23,
                        ),
                        suffixIcon: const SizedBox(
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(MingCute.close_line, color: Colors.grey),
                              SizedBox(width: 10),
                              Icon(MingCute.list_search_line,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      MinimalHeadingText(
                          leftText: "Categories", rightText: "See all"),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildCategoryCircle(
                                icons[index], title[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      MinimalHeadingText(
                          leftText: "Nearby shops", rightText: "See all"),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 28,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildSquareCategoryButton(
                                title[index],
                                index == 0
                                    ? tertiaryColor.withOpacity(0.2)
                                    : Colors.grey.shade300,
                                index == 0
                                    ? primaryColor
                                    : Colors.grey.shade300,
                                index == 0 ? primaryColor : Colors.black54);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return shopContainer(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scrollBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      //enableDrag: true,
      //useSafeArea: true,
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return FilterScreen();
          },
        );
      },
    );
  }

  Widget shopContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/shopinfo');
      },
      child: Container(
        height: 95,
        margin: const EdgeInsets.symmetric(vertical: 3),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
          border: Border.all(
            width: 0.6,
            color: secondaryColor,
          ),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/img.jpg")),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(
                      width: 210,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.visible,
                              'Captain Barbershop',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    wordSpacing: 2,
                                    //color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      'Lafa Street, Gbawe-Accra',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      MingCute.location_fill,
                                      size: 12,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      overflow: TextOverflow.visible,
                                      '1.2 km',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 17),
                                Row(
                                  children: [
                                    const Icon(
                                      MingCute.star_fill,
                                      size: 12,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      overflow: TextOverflow.visible,
                                      '4.8',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment
                            //           .start,
                            //   children: [
                            //     // const SizedBox(width: 15),
                            //     for (int i =
                            //             1;
                            //         i <=
                            //             service
                            //                 .ratings!
                            //                 .toInt();
                            //         i++)
                            //       const Icon(
                            //         Icons
                            //             .star,
                            //         color: Colors
                            //             .amber,
                            //         size: 14,
                            //       ),
                            //     const SizedBox(
                            //         width: 5),
                            //     Text(
                            //         "(${service.ratings}.5)",
                            //         style: Theme.of(
                            //                 context)
                            //             .textTheme
                            //             .bodySmall!
                            //             .copyWith(
                            //               fontSize:
                            //                   10,
                            //               color:
                            //                   Colors.black,
                            //             )),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCircle(Icon icon, String title) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            // border: Border.all(
            //   width: 0.8,
            //   color: primaryColor,
            // ),
            color: tertiaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget _buildSquareCategoryButton(
      String title, Color bgcolor, Color brcolor, Color textcolor) {
    return Container(
      height: 28,
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgcolor,
        border: Border.all(
          width: 0.8,
          color: brcolor,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: textcolor,
                fontSize: 11,
              ),
        ),
      ),
    );
  }
}
