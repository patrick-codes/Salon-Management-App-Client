import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';
import 'package:salonapp_client/presentation/authentication%20screens/repository/data%20model/user_model.dart';
import 'package:salonapp_client/presentation/location/bloc/location_bloc.dart';
import '../../helpers/colors/widgets/style.dart';
import '../checkout page/components/Transaction/other/show_up_animation.dart';
import '../filter screen/pages/filter_screen.dart';
import '../shops/bloc/home shop bloc/h_shops_bloc.dart';
import '../shops/components/gridview.dart';
import '../shops/repository/data rmodel/h_shop_service_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<String> svgs = <String>[
    "undraw_barber_utly",
    "undraw_people_ka7y",
    "undraw_pie-graph_8m6b",
  ];

  String photoUrl =
      "https://media.istockphoto.com/id/2166854040/photo/chairs-by-sink-bowl-at-hair-salon.webp?a=1&b=1&s=612x612&w=0&k=20&c=UltW4fSClI85zl07M0pmi4-uqjcUC4ADd4xfwBS6nWc=";
  List<HomeShopModel>? shops;
  UserModel? user;
  bool isLoaded = false;
  final searchController = TextEditingController();
  String text = 'No shops available !!';
  Future<void> refresh(BuildContext context) async {
    setState(() {
      context.read<HomeShopsBloc>().add(ViewHomeShopsEvent());
      debugPrint("Refreshed");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userBloc =
    //     context.read<AuthBloc>().add(CurrentUserEvent(user!.id ?? ''));
    return BlocConsumer<HomeShopsBloc, HomeShopsState>(
      listener: (context, state) {
        if (state is ShopsLoadingState) {
          CircularProgressIndicator();
        }
        if (state is HomeShopInitial) {
          context.read<HomeShopsBloc>().add(ViewHomeShopsEvent());
        }
      },
      builder: (BuildContext context, state) {
        if (state is ShopsFetchFailureState) {
          Center(child: Text(state.errorMessage));
        } else if (state is ShopsFetchedState) {
          shops = state.shop;
          isLoaded = true;
          debugPrint("Shops Fetched:${state.shop!.length}");
        }

        return Scaffold(
          backgroundColor: secondaryColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    // color: primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [
                        primaryColor,
                        Colors.deepOrange,
                      ],
                    ),
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
                            Container(
                              height: 35,
                              width: 235,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(width: 3),
                                    Icon(
                                      MingCute.location_2_fill,
                                      color: primaryColor,
                                    ),
                                    SizedBox(width: 3),
                                    BlocConsumer<LocationBloc, LocationState>(
                                      listener: (context, locationState) {
                                        if (locationState is LocationOff) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Location Error: ${locationState.message}")),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is LocationFetchedState) {
                                          return Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            state.address!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                ),
                                          );
                                        } else
                                          return Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            "Location loading......",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                          );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      user?.profilePhoto ?? photoUrl,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            size: 50, color: Colors.red);
                                      },
                                      fit: BoxFit.cover,
                                    ).image,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        RichText(
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Let's find your                                       ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                              TextSpan(
                                text: "top Salon & Barber shop!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: searchController,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                          onChanged: (value) => context
                              .read<HomeShopsBloc>()
                              .add(SearchShopEvent(
                                  query: searchController.text)),
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
                                const TextStyle(color: iconGrey, fontSize: 15),
                            prefixIcon: const Icon(
                              MingCute.search_2_line,
                              color: iconGrey,
                              size: 23,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                scrollBottomSheet(context);
                              },
                              child: const SizedBox(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    Icon(MingCute.list_search_line,
                                        color: iconGrey),
                                  ],
                                ),
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 15.0,
                    right: 15,
                  ),
                  child: MinimalHeadingText(
                    leftText: "Categories",
                    rightText: "See all",
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: svgs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return ShowUpAnimation(
                                delay: 300,
                                child: buildDisCountCard(
                                    icons[index],
                                    title[index],
                                    "assets/svgs/${svgs[index]}.svg"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: MinimalHeadingText(
                      leftText: "Nearby shops", rightText: "See all"),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: icons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return ShowUpAnimation(
                              delay: 300,
                              child: _buildSquareCategoryButton(
                                  title[index],
                                  index == 0
                                      ? tertiaryColor.withOpacity(0.2)
                                      : Colors.grey.shade300,
                                  index == 0
                                      ? primaryColor
                                      : Colors.grey.shade300,
                                  index == 0 ? primaryColor : Colors.black54),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                shops == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            SpinKitDoubleBounce(
                              // lineWidth: 3,
                              size: 40,
                              color: primaryColor,
                            ),
                            SizedBox(height: 8),
                            PrimaryText(
                              text: 'Loading nearby shops....',
                              color: secondaryColor3,
                              size: 12,
                            ),
                          ],
                        ),
                      )
                    : (shops == null || shops == 0 || shops!.isEmpty)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 45),
                                SvgPicture.asset(
                                  'assets/svgs/undraw_file-search_cbur.svg',
                                  height: 80,
                                  width: 80,
                                ),
                                SizedBox(height: 14),
                                PrimaryText(
                                  text: text,
                                  color: iconGrey,
                                  size: 11,
                                ),
                              ],
                            ),
                          )
                        : ShowUpAnimation(
                            delay: 300,
                            child: GridViewComponent(
                              shops: shops!,
                            ),
                          ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDisCountCard(
    Icon icon,
    String title,
    String imgs,
  ) {
    return Column(
      children: [
        Container(
          height: 130,
          width: 340,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: secondaryColor2,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 1,
                color: secondaryColor2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: "25 % Discount",
                      color: blackColor,
                      fontWeight: FontWeight.w600,
                      size: 20,
                    ),
                    SizedBox(height: 2),
                    PrimaryText(
                      text: "Learn style, Kumasi",
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      size: 11,
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/appointments');
                      },
                      child: Container(
                        height: 30,
                        width: 105,
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "View all Shops",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      imgs,
                      height: 106,
                      width: 108,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          height: 100,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
      ),
    );
  }

  Widget buildCategoryCircle(Icon icon, String title) {
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 5,
      ),
      child: Container(
        height: 28,
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 0),
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
      ),
    );
  }
}
