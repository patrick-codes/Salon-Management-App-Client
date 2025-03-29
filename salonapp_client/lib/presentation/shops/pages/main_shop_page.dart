// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import 'package:salonapp_client/presentation/shops/bloc/shops_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helpers/colors/color_constants.dart';
import '../../../helpers/colors/widgets/custom_button.dart';
import '../../../helpers/colors/widgets/minimal_heading.dart';
import '../../checkout page/components/Transaction/other/show_up_animation.dart';
import '../../checkout page/pages/checkout_new.dart';
import '../components/services_grid.dart';
import '../repository/data rmodel/service_model.dart';

class MainShopinfoPage extends StatefulWidget {
  String? id;
  MainShopinfoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<MainShopinfoPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<MainShopinfoPage> {
  List<String> imgs = <String>[
    "assets/images/img-sixteen.jpg",
    "assets/images/img-ten.jpg",
    "assets/images/img-seventeen.jpg",
    "assets/images/img4.jpeg",
    "assets/images/img5.jpg",
    "assets/images/img-thirteen.jpg",
  ];
  List<String> services = <String>[
    "Shaving and Shapping",
    "Beard Trim",
    "Cut & Dye",
    "Color Dye",
    "Sporting Haircut Guys",
    "Sporting Haircut Ladies",
  ];
  List<String> prices = <String>[
    "GHC 20",
    "GHC 30",
    "GHC 25",
    "GHC 40",
    "GHC 45",
    "GHC 50",
  ];
  List<Icon> icons = <Icon>[
    const Icon(
      MingCute.whatsapp_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.phone_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.location_line,
      color: primaryColor,
      size: 30,
    ),
    const Icon(
      MingCute.share_2_line,
      color: primaryColor,
      size: 30,
    ),
  ];
  List<String> title = <String>[
    "WhatsApp",
    "Call",
    "Direction",
    "Share",
  ];
  bool isOpen = true;
  ShopModel? shop;
  String text = 'No shops available !!';
  @override
  void initState() {
    super.initState();
    context.read<ShopsBloc>().add(ViewSingleShopEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopsBloc, ShopsState>(
      listener: (context, state) {
        if (state is ShopsLoadingState) {
          CircularProgressIndicator();
        } else if (state is ShopsFetchFailureState) {
          Center(child: Text(state.errorMessage));
        } else if (state is SingleShopsFetchedState) {
          shop = state.shop;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: shop == null
                ? SizedBox.shrink()
                : const Icon(
                    MingCute.arrow_left_fill,
                    color: Colors.white,
                  ),
            actions: [
              shop == null
                  ? SizedBox.shrink()
                  : Container(
                      height: 23,
                      width: 90,
                      decoration: BoxDecoration(
                        color:
                            shop!.isOpen == false ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          shop!.isOpen == false ? "SHOP CLOSED" : "SHOP OPENED",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                        ),
                      ),
                    ),
              SizedBox(width: 8),
            ],
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: shop == null
              ? SizedBox.shrink()
              : Container(
                  height: 90,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade100,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: ShowUpAnimation(
                        delay: 300,
                        child: CustomButton(
                          text: "Book Now",
                          onpressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CheckoutScreen(),
                              ),
                            );
                          },
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
          body: shop == null
              ? const Center(
                  child: SpinKitDoubleBounce(
                    // lineWidth: 3,
                    size: 60,
                    color: primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: shop!.profileImg ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: shop!.profileImg != null
                                ? DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 137,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(top: BorderSide.none),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        backgroundColor.withOpacity(0.2),
                                        backgroundColor
                                      ],
                                    ),
                                    color: backgroundColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shop!.shopName ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.25,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      MingCute.calendar_2_fill,
                                                      size: 20,
                                                      color: primaryColor,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      'Days: ${shop!.openingDays}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 11,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      MingCute.clock_2_fill,
                                                      size: 20,
                                                      color: primaryColor,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      shop!.operningTimes ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 11,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      MingCute.location_fill,
                                                      color: primaryColor,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      shop!.location ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      MingCute.route_fill,
                                                      size: 20,
                                                      color: primaryColor,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      "${shop!.distanceToUser.ceil()}km away",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[200]!,
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.35,
                              decoration: BoxDecoration(
                                color: secondaryColor3,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 20),
                      ShowUpAnimation(
                        delay: 300,
                        child: SizedBox(
                          height: 85,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: icons.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              debugPrint(
                                  "Passed shop cordinates: ${shop!.cordinates}");
                              return buildCategorySquare(icons[index],
                                  title[index], index, shop!.cordinates);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: GestureDetector(
                          onTap: () => scrollBottomSheet(context),
                          child: MinimalHeadingText(
                            leftText: 'What service we provide',
                            rightText: 'View all',
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      ShowUpAnimation(
                        delay: 300,
                        child: SizedBox(
                          height: 125,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: imgs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return buildServicesSquare(
                                imgs[index],
                                services[index],
                                prices[index],
                                index == 1
                                    ? primaryColor
                                    : Colors.grey.shade200,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: MinimalHeadingText(
                          leftText: 'Our latest works',
                          rightText: 'View all',
                        ),
                      ),
                      const SizedBox(height: 13),
                      ShowUpAnimation(
                        delay: 300,
                        child: SizedBox(
                          height: 125,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: shop!.workImgs!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return buildLatestWorksSquare(
                                shop!.workImgs![index],
                                // services[index],
                                // prices[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
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
            return SizedBox(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: imgs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return buildServicesSquareFull(
                    imgs[index],
                    services[index],
                    prices[index],
                    index == 1 ? primaryColor : Colors.grey.shade200,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildServicesSquare(
      String imgurl, String services, String prices, Color brColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 125,
          width: 115,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: brColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryText(
                      text: prices,
                      size: 15,
                      color: Colors.red[500]!,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    )
                  ],
                ),
                SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                          ),
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

  Widget buildServicesSquareFull(
      String imgurl, String services, String prices, Color brColor) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 125,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1.5,
              color: brColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(imgurl).image,
                    ),
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        services,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              //fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        "Female",
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 15,
                              color: iconGrey,
                            ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        prices,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLatestWorksSquare(
    String imgurl,
    // String title,
    // String prices,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imgurl,
          imageBuilder: (context, imageProvider) => Container(
            height: 115,
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          placeholder: (context, url) => Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Container(
                height: 115,
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: secondaryColor3,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }

  Widget buildCategorySquare(
      Icon icons, String title, index, List<double?> cordinates) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (index == 2) {
              Navigator.pushNamed(
                context,
                '/map',
                arguments: {
                  'latlng': [cordinates[0], cordinates[1]]
                },
              );
              debugPrint("latlng: ${[cordinates[0], cordinates[1]]}");
            }
          },
          child: Container(
            height: 63,
            width: 63,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: tertiaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: icons,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: iconGrey,
              ),
        ),
      ],
    );
  }
}
