import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:m_toast/m_toast.dart';
import 'package:salonapp_client/presentation/appointments/bloc/appointment_bloc.dart';
import 'package:salonapp_client/presentation/checkout%20page/components/Transaction/other/show_up_animation.dart';
import 'package:salonapp_client/presentation/checkout%20page/components/cedi_sign_component.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helpers/colors/color_constants.dart';
import '../../../helpers/colors/widgets/style.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers/widgets/text_widgets.dart';
import '../bloc/all appointments bloc/all_appm_bloc.dart';

class AppointmentsPage extends StatefulWidget {
  AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    context.read<AllAppointmentBloc>().add(ViewAllAppointmentEvent());
    super.initState();
  }

  Future<void> refresh(BuildContext context) async {
    setState(() {
      context.read<AllAppointmentBloc>().add(ViewAllAppointmentEvent());
      debugPrint("Refreshed");
    });
  }

  @override
  Widget build(BuildContext context) {
    ShowMToast toast = ShowMToast(context);
    return BlocConsumer<AllAppointmentBloc, AllAppointmentState>(
      listener: (context, state) {
        if (state is AllAppointmentsFetchFailureState) {
          toast.errorToast(
            message: state.errorMessage,
            alignment: Alignment.topCenter,
          );
        } else if (state is AllAppointmentDeletedSuccesState) {
          setState(() {
            context.read<AllAppointmentBloc>().add(ViewAllAppointmentEvent());
          });
          toast.successToast(
            message: state.message,
            alignment: Alignment.topCenter,
          );
        } else if (state is AllAppointmentDeletedFailureState) {
          toast.errorToast(
            message: state.message,
            alignment: Alignment.topCenter,
          );
        }
      },
      builder: (context, state) {
        if (state is AllAppointmentsFetchedState) {
          return Scaffold(
            backgroundColor: secondaryBg,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const Icon(
                MingCute.arrow_left_fill,
              ),
              centerTitle: true,
              title: Text(
                "Appointments (${state.appointment!.length})",
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: RefreshIndicator(
                    onRefresh: () => refresh(context),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 180,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: state.appointment!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              var appoint = state.appointment![index];
                              return ShowUpAnimation(
                                delay: 150,
                                child: ListTile(
                                  tileColor: whiteColor,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/receipt',
                                      arguments: {
                                        'id': appoint.id,
                                        'name': appoint.shopName,
                                        'datetime': appoint.appointmentDate,
                                        'amount': appoint.amount,
                                        'receiptId': appoint.bookingCode,
                                        'phone': appoint.phone,
                                        'service': appoint.servicesType,
                                      },

                                      //  appointmentContainer(
                                      //   context,
                                      //   appoint!.id ?? '',
                                      //   appoint.imgUrl ?? '',
                                      //   appoint.shopName!,
                                      //   appoint.amount ?? 0.0,
                                      //   appoint.appointmentTime.toString(),
                                      //   appoint.servicesType ?? '',
                                      //   appoint.appointmentDate.toString(),
                                      //   appoint.location ?? '',
                                      //   appoint.bookingCode ?? '',
                                      //   appoint.phone ?? '',
                                      // ),
                                    );
                                  },
                                  dense: true,
                                  horizontalTitleGap: 15,
                                  minVerticalPadding: 10,
                                  minTileHeight: 10,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                  leading: Container(
                                    height: 150,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: appoint!.imgUrl ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 158,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider,
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[200]!,
                                          child: Container(
                                            height: 95,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                          SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: const Icon(
                                              Icons.error,
                                              color: iconGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: headingTextMedium(
                                    context,
                                    appoint.shopName!,
                                    FontWeight.w500,
                                    14,
                                    blackColor,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      subheadingTextMedium(
                                        context,
                                        appoint.bookingCode.toString()!,
                                        12.5,
                                        iconGrey,
                                      ),
                                      SizedBox(height: 5),
                                      subheadingTextMedium(
                                        context,
                                        appoint.servicesType!,
                                        12,
                                        Colors.black87,
                                      ),
                                      SizedBox(height: 10),
                                      Divider(),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      context.read<AllAppointmentBloc>()
                                        ..add(
                                          DeleteAllAppointmentEvent(
                                              id: appoint.id ?? ''),
                                        );
                                    },
                                    icon: Icon(
                                      MingCute.delete_line,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is AllAppointmentsFetchFailureState) {
          return Scaffold(
            backgroundColor: secondaryBg,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: primaryColor,
                statusBarIconBrightness: Brightness.light,
              ),
              backgroundColor: Colors.white,
              leading: const Icon(
                MingCute.arrow_left_fill,
              ),
              centerTitle: true,
              title: Text(
                "Appointments",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: RefreshIndicator(
                  onRefresh: () => refresh(context),
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
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: secondaryBg,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
            leading: const Icon(
              MingCute.arrow_left_fill,
            ),
            centerTitle: true,
            title: Text(
              "Appointments",
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
                text: 'Loading appointments....',
                color: secondaryColor3,
                size: 13,
              ),
            ],
          ),
        );
      },
    );
  }

  Container appointmentContainer(
    BuildContext context,
    String id,
    String imgurl,
    String name,
    double amount,
    String time,
    String service,
    String date,
    String location,
    String code,
    String phone,
  ) {
    return Container(
      height: 245,
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CediSign(
                      size: 16.5,
                      weight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 2),
                    Text(
                      amount.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imgurl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 158,
                        width: 90,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[200]!,
                          child: Container(
                            height: 95,
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
                      errorWidget: (context, url, error) => SizedBox(
                        height: 40,
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: const Icon(
                              Icons.error,
                              color: iconGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.visible,
                              name,
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
                                      location,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black45,
                                            fontSize: 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  overflow: TextOverflow.visible,
                                  'Service Type',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              overflow: TextOverflow.visible,
                              service,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: iconGrey,
                                    fontSize: 13,
                                  ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 35,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/receipt',
                                          arguments: {
                                            'id': id,
                                            'name': name,
                                            'datetime': date,
                                            'amount': amount,
                                            'receiptId': code,
                                            'phone': phone,
                                            'service': service,
                                          },
                                        );
                                        // context.read<AllAppointmentBloc>().add(
                                        //       DeleteAppointmentEvent(
                                        //           id: id),
                                        //     );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "View Receipt",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
