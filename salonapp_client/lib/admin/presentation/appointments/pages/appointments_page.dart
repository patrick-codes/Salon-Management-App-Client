import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/config/size_config.dart';
import '../../../helpers/constants/color_constants.dart';
import '../../../helpers/text style/text_style.dart';
import '../bloc/owner_appointment_bloc.dart';
import '../repository/data model/owner_appointment_model.dart';

class OwnerAppointmentsPage extends StatefulWidget {
  const OwnerAppointmentsPage({super.key});

  @override
  State<OwnerAppointmentsPage> createState() => _OwnerAppointmentsPageState();
}

class _OwnerAppointmentsPageState extends State<OwnerAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    // Always trigger fetch when entering page
    context.read<OwnerAppointmentBloc>().add(ViewOwnerAppointmentEvent());
  }

  Future<void> markAllAppointmentsAsSeen(
      List<OwnerAppointmentModel?> appointments) async {
    final prefs = await SharedPreferences.getInstance();
    final ids =
        appointments.where((a) => a?.id != null).map((a) => a!.id!).toList();
    await prefs.setStringList('seen_appointment_ids', ids);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerAppointmentBloc, OwnerAppointmentState>(
      listener: (context, state) {
        if (state is OwnerAppointmentsFetchedState) {
          markAllAppointmentsAsSeen(state.appointment ?? []);
        }
        if (state is OwnerAppointmentsFetchFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is OwnerAppointmentsLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is OwnerAppointmentsFetchFailureState) {
          return Scaffold(
            backgroundColor: secondaryBg,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/undraw_file-search_cbur.svg',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 20),
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

        if (state is OwnerAppointmentsFetchedState) {
          final appointments = state.appointment ?? [];
          return Scaffold(
            backgroundColor: barBg,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: iconGrey,
                statusBarIconBrightness: Brightness.light,
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(MingCute.arrow_left_fill),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                "Appointments (${appointments.length})",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(MingCute.more_2_fill),
                  onPressed: () {},
                ),
              ],
            ),
            body: appointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/undraw_file-search_cbur.svg',
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(height: 20),
                        const PrimaryText(
                          text: 'No Appointments Found',
                          color: iconGrey,
                          size: 15,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appt = appointments[index];
                      if (appt == null) return const SizedBox.shrink();

                      return Container(
                        height: 170,
                        width: SizeConfig.screenWidth,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(MingCute.scissors_2_line,
                                        size: 15, color: iconGrey),
                                    const SizedBox(width: 5),
                                    PrimaryText(
                                      text: appt.servicesType ?? '',
                                      size: 15,
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(MingCute.phone_line,
                                        size: 15, color: iconGrey),
                                    const SizedBox(width: 5),
                                    PrimaryText(
                                      text: appt.phone ?? '',
                                      size: 13,
                                      color: iconGrey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(MingCute.calendar_line,
                                        size: 15, color: iconGrey),
                                    const SizedBox(width: 5),
                                    PrimaryText(
                                      text: appt.appointmentDate
                                              ?.toLocal()
                                              .toString()
                                              .split(' ')[0] ??
                                          '',
                                      size: 13,
                                      color: blackColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(MingCute.clock_2_line,
                                        size: 15, color: iconGrey),
                                    const SizedBox(width: 5),
                                    PrimaryText(
                                      text: appt.appointmentDate
                                              ?.toLocal()
                                              .toString()
                                              .split(' ')[1] ??
                                          '',
                                      size: 13,
                                      color: blackColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 30,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: const Center(
                                    child: PrimaryText(
                                      text: 'End service',
                                      size: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const PrimaryText(
                                    text: 'PAID',
                                    size: 13,
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  PrimaryText(
                                    text: appt.amount?.toString() ?? '0',
                                    size: 13.5,
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        }

        // Default fallback
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
