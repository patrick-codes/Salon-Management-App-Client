import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:googleapis/mybusinesslodging/v1.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import 'package:salonapp_client/presentation/filter%20screen/pages/filter_screen.dart';
import 'package:salonapp_client/presentation/shops/repository/data%20rmodel/h_shop_service_model.dart';
import '../../../../helpers/colors/color_constants.dart';
import '../../../checkout page/components/Transaction/other/show_up_animation.dart';
import '../../../location/bloc/location_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/home shop bloc/h_shops_bloc.dart';

class ShopsPage extends StatefulWidget {
  ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  List<HomeShopModel>? shops;
  bool isLoaded = false;
  bool isFavClicked = false;
  final searchController = TextEditingController();
  String text = 'No shops available !!';
  HomeShopsBloc? HomeshopsBloc;
  String? address;
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> refresh(BuildContext context) async {
    setState(() {
      context.read<HomeShopsBloc>().add(ViewHomeShopsEvent());
      debugPrint("Refreshed");
    });
  }

  String? selectedService;
  String? selectedGender;
  double? selectedDistance;
  RangeValues? selectedPriceRange;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final locationState = context.watch<LocationBloc>().state;
    return BlocConsumer<HomeShopsBloc, HomeShopsState>(
        listener: (context, state) {
      if (state is ShopsFetchFailureState) {
        debugPrint("Shops Fetch Error: ${state.errorMessage}");
      }
    }, builder: (context, state) {
      // if (locationState is LocationFailure) {
      //   return Container(
      //     color: secondaryBg,
      //     child: Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(
      //             Icons.location_off_rounded,
      //             color: Colors.black26,
      //             size: 80,
      //           ),
      //           SizedBox(height: 18),
      //           PrimaryText(
      //             fontWeight: FontWeight.w200,
      //             size: 15,
      //             color: iconGrey,
      //             text:
      //                 "Turn on your device's location service or wait for app to fetch device location to access nearby shops.",
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // }

      // if (locationState is LocationFetchedState) {
      //   address = locationState.address2;
      //   if (state is! ShopsFetchedState && state is! ShopsLoadingState) {
      //     context.read<HomeShopsBloc>().add(ViewHomeShopsEvent());
      //   }
      // }

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
            preferredSize: Size.fromHeight(166),
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
                      centerTitle: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Available Shops ",
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          shops!.isNotEmpty || shops!.length > 0
                              ? Text(
                                  "(${shops?.length})",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    ShowUpAnimation(
                      delay: 150,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) => context
                            .read<HomeShopsBloc>()
                            .add(SearchShopEvent(query: searchController.text)),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                            ),
                        decoration: InputDecoration(
                          hintText: "Search by shop name....",
                          hintStyle: TextStyle(fontSize: 13, color: iconGrey),
                          prefixIcon:
                              Icon(MingCute.search_3_line, color: iconGrey),
                          suffixIcon: SizedBox(
                            width: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => searchController.clear(),
                                  child: Icon(
                                    MingCute.close_circle_fill,
                                    color: iconGrey,
                                  ),
                                ),
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
                    ), // Inside AppBar column (under the TextFormField)
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildDropdown<String>(
                            label: "Services",
                            icon: Icons.cut,
                            items: [
                              "Haircut",
                              "Braids",
                              "Shaving",
                              "Nails",
                              "Locks",
                            ],
                            value: selectedService,
                            onChanged: (value) {
                              setState(() => selectedService = value);
                              context.read<HomeShopsBloc>().add(
                                    SearchShopEvent(
                                      query: searchController.text,
                                      service: value,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildDropdown<String>(
                            label: "Gender",
                            icon: Icons.person,
                            items: ["Male", "Female", "Unisex"],
                            value: selectedGender,
                            onChanged: (value) {
                              setState(() => selectedGender = value);
                              context.read<HomeShopsBloc>().add(
                                    SearchShopEvent(
                                      query: searchController.text,
                                      gender: value,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildDropdown<double>(
                            label: "Distance km",
                            icon: Icons.location_on,
                            items: [2.0, 5.0, 10.0, 20.0],
                            value: selectedDistance,
                            onChanged: (value) {
                              setState(() => selectedDistance = value);
                              context.read<HomeShopsBloc>().add(
                                    SearchShopEvent(
                                      query: searchController.text,
                                      distance: value,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildDropdown<RangeValues>(
                            label: "Price Range",
                            icon: Icons.attach_money,
                            items: const [
                              RangeValues(0, 20),
                              RangeValues(20, 50),
                              RangeValues(50, 100),
                            ],
                            itemToString: (range) =>
                                "GHS ${range.start.toInt()}–${range.end.toInt()}",
                            value: selectedPriceRange, // ✅
                            onChanged: (value) {
                              setState(() => selectedPriceRange = value);
                              context.read<HomeShopsBloc>().add(
                                    SearchShopEvent(
                                      query: searchController.text,
                                      priceRange: value,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: state is ShopsLoadingState
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
                                      var shopInfo = state.shop![index];

                                      if (state.shop!.isEmpty) {
                                        return const Center(
                                            child: Text(
                                                "No shops match your filters"));
                                      }
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
                                          shopInfo.category,
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
              size: 60,
              color: primaryColor,
            ),
            SizedBox(height: 20),
            PrimaryText(
              text: 'Loading shops....',
              color: secondaryColor3,
              size: 13,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required List<T> items,
    required T? value,
    required Function(T?) onChanged,
    String Function(T)? itemToString,
    Color borderColor = Colors.black12,
  }) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          DropdownButton<T>(
            value: value,
            underline: const SizedBox(), // removes default underline
            elevation: 2,
            dropdownColor: Colors.white,
            focusColor: Colors.grey[300],
            hint: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemToString != null ? itemToString(item) : item.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> scrollBottomSheet(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
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

  Container appointmentContainer(
    BuildContext context,
    String? id,
    String? img,
    String? name,
    String? location,
    String? openingDays,
    String? openingTime,
    List<HomeService>? services,
    bool? isLoaded,
    double? distance,
    bool? isOpen,
    String? category,
  ) {
    return Container(
      height: 340,
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
                          services != null && services!.isNotEmpty
                              ? services!
                                  .map((s) => "${s.name} - \$${s.price}")
                                  .join(", ")
                              : "No services available",
                          overflow: TextOverflow.visible,
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
                            Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.male,
                                      size: 22,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      category ?? 'Category',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black45,
                                            fontSize: 12.5,
                                          ),
                                    ),
                                  ],
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
                                height: 40,
                                width: 180,
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
                                          fontSize: 12.5,
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
