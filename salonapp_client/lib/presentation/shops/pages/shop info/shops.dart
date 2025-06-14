import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import '../../../../helpers/colors/color_constants.dart';
import '../../../checkout page/components/Transaction/other/show_up_animation.dart';
import '../../../location/bloc/location_bloc.dart';
import '../../bloc/shops_bloc.dart';
import '../../repository/data rmodel/service_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ShopsPage extends StatefulWidget {
  ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  List<ShopModel>? shops;
  bool isLoaded = false;
  List<String> imgs = <String>[
    "assets/images/img8.jpg",
    "assets/images/img.jpg",
    "assets/images/img3.jpg",
    "assets/images/img5.jpg",
    "assets/images/img9.jpg",
    "assets/images/img6.jpg",
    "assets/images/img3.jpg",
    "assets/images/img5.jpg",
    "assets/images/img9.jpg",
    "assets/images/img6.jpg",
  ];
  bool isFavClicked = false;
  final searchController = TextEditingController();
  String text = 'No nearby shops available !!';
  ShopsBloc? shopsBloc;
  String? address;
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> refresh(BuildContext context) async {
    setState(() {
      context.read<ShopsBloc>().add(ViewShopsEvent());
      debugPrint("Refreshed");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final locationState = context.watch<LocationBloc>().state;
    return BlocConsumer<ShopsBloc, ShopsState>(listener: (context, state) {
      if (state is ShopsFetchFailureState) {
        debugPrint("Shops Fetch Error: ${state.errorMessage}");
      }
    }, builder: (context, state) {
      if (locationState is LocationFailure) {
        return Container(
          color: secondaryBg,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_rounded,
                  color: Colors.black26,
                  size: 80,
                ),
                SizedBox(height: 18),
                PrimaryText(
                  fontWeight: FontWeight.w200,
                  size: 15,
                  color: iconGrey,
                  text:
                      "Turn on your device's location service or wait for app to fetch device location to access nearby shops.",
                ),
              ],
            ),
          ),
        );
      }

      if (locationState is LocationFetchedState) {
        address = locationState.address2;
        if (state is! ShopsFetchedState && state is! ShopsLoadingState) {
          context.read<ShopsBloc>().add(ViewShopsEvent());
        }
      }

      if (state is ShopsFetchFailureState) {
        return Scaffold(
          backgroundColor: secondaryBg,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/undraw_file-search_cbur.svg',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                PrimaryText(
                  text: state.errorMessage,
                  color: iconGrey,
                  size: 15,
                ),
              ],
            ),
          ),
        );
      }

      if (state is ShopsFetchedState) {
        shops = state.shop;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Shops around ${address}",
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          // shops!.isEmpty
                          //     ? SizedBox.shrink()
                          //     : Text(
                          //         " (${state.shop!.length})",
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodyLarge!
                          //             .copyWith(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //       ),
                        ],
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
                    ShowUpAnimation(
                      delay: 150,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) => context
                            .read<ShopsBloc>()
                            .add(SearchShopEvent(query: searchController.text)),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                            ),
                        decoration: InputDecoration(
                          hintText: "Search....",
                          hintStyle: TextStyle(fontSize: 13, color: iconGrey),
                          prefixIcon:
                              Icon(MingCute.search_3_line, color: iconGrey),
                          suffixIcon: const SizedBox(
                            width: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(MingCute.close_line, color: iconGrey),
                                SizedBox(width: 10),
                                Icon(MingCute.list_search_line,
                                    color: iconGrey),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: state is ShopsLoadingState ||
                  // locationState is InitLocation ||
                  locationState is LocationLoading
              ? Container(
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDoubleBounce(
                          // lineWidth: 3,
                          size: 60,
                          color: primaryColor,
                        ),
                        SizedBox(height: 20),
                        PrimaryText(
                          text: 'Loading nearby shops....',
                          color: secondaryColor3,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                )
              : shops!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/undraw_file-search_cbur.svg',
                            height: 150,
                            width: 150,
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text: text,
                            color: iconGrey,
                            size: 15,
                          ),
                        ],
                      ),
                    )
                  : SafeArea(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: RefreshIndicator(
                          color: blackColor,
                          onRefresh: () => refresh(context),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    itemCount: shops!.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var shopInfo = shops![index];

                                      return ShowUpAnimation(
                                        delay: 150,
                                        child: appointmentContainer(
                                          context,
                                          shopInfo.shopId,
                                          shopInfo.profileImg,
                                          shopInfo.shopName,
                                          shopInfo.location,
                                          shopInfo.openingDays,
                                          shopInfo.operningTimes,
                                          shopInfo.services,
                                          isLoaded,
                                          shopInfo.distanceToUser,
                                          shopInfo.isOpen,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      }
      return Scaffold(
        backgroundColor: secondaryBg,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              // lineWidth: 3,
              size: 60,
              color: primaryColor,
            ),
            SizedBox(height: 20),
            PrimaryText(
              text: 'Loading nearby shops....',
              color: secondaryColor3,
              size: 13,
            ),
          ],
        ),
      );
    });
  }

  Container appointmentContainer(
    BuildContext context,
    String? id,
    String? img,
    String? name,
    String? location,
    String? openingDays,
    String? openingTime,
    String? services,
    bool? isLoaded,
    double? distance,
    bool? isOpen,
  ) {
    return Container(
      height: 330,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: secondaryColor,
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
                CachedNetworkImage(
                  imageUrl: img ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: imageProvider,
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
                          top: 5,
                          right: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 23,
                              width: 90,
                              decoration: BoxDecoration(
                                color:
                                    isOpen == false ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  isOpen == false
                                      ? "SHOP CLOSED"
                                      : " SHOP OPENED",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                ],
                              ),
                              color: backgroundColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        MingCute.location_fill,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        location ?? '',
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
                                  Row(
                                    children: [
                                      Icon(
                                        MingCute.route_fill,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        "${distance!.ceil()}km away",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                      ),
                                      SizedBox(width: 25),
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
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: secondaryColor3,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: const Icon(Icons.error)),
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
                          name ?? '',
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
                                  'Days: $openingDays',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black45,
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
                                  openingTime!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black45,
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          overflow: TextOverflow.visible,
                          services!,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                    fontSize: 13,
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
                                Navigator.pushNamed(
                                  context,
                                  '/mainshopinfo',
                                  arguments: {'id': id},
                                );
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
                                          fontWeight: FontWeight.w700,
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
