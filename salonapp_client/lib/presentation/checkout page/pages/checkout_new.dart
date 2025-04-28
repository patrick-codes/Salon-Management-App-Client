// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:quickalert/quickalert.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import 'package:salonapp_client/presentation/appointments/bloc/appointment_bloc.dart';
import 'package:salonapp_client/presentation/authentication%20screens/repository/data%20model/user_model.dart';
import '../../../helpers/colors/color_constants.dart';
import '../components/Transaction/other/show_up_animation.dart';
import '../components/Transaction/other/text.dart';
import '../components/cedi_sign_component.dart';
import 'package:m_toast/m_toast.dart';

class CheckoutScreen extends StatefulWidget {
  String? serviceType;
  double? amount;
  UserModel? user;
  String? shop;
  String? location;
  String? id;
  String? phone;
  String? imgurl;

  CheckoutScreen({
    Key? key,
    required this.serviceType,
    required this.amount,
    this.user,
    required this.shop,
    required this.location,
    required this.id,
    this.phone,
    this.imgurl,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  String process = "Pay";
  CurrencyCode selectedCurrency = CurrencyCode.GHS;
  late DateTime selectedValue = DateTime.now();
  Time time = Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  bool isLoading = false;
  TimeOfDay? selectedTime;

  double totalCharged() {
    double total = widget.amount! + 2;
    return total;
  }

  Time convertTimeOfDayToTime(Time? timeOfDay) {
    return Time(hour: timeOfDay!.hour, minute: timeOfDay.minute);
  }

  @override
  Widget build(BuildContext context) {
    ShowMToast toast = ShowMToast(context);
    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listener: (BuildContext context, AppointmentState state) {
        if (state is AppointmentCreatedSuccesState) {
          debugPrint("Booking code: ${state.code}");
          QuickAlert.show(
            context: context,
            animType: QuickAlertAnimType.slideInUp,
            type: QuickAlertType.success,
            confirmBtnColor: blackColor,
            title: 'Appointment Booked!!',
            text: 'Salon appointment booked successfully',
            confirmBtnText: 'Back Home',
            confirmBtnTextStyle: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/mainhome', (Route<dynamic> route) => false);
            },
          );
        }
        if (state is AppointmentsLoadingState) {
          isLoading = true;
        }
        if (state is AppointmentCreateFailureState) {
          toast.errorToast(
            message: state.error,
            alignment: Alignment.topCenter,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                MingCute.arrow_left_fill,
              ),
            ),
            centerTitle: true,
            title: Text(
              "Schedule Appointment",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            backgroundColor: secondaryColor,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black26,
                    ),
                    // color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DatePicker(
                    height: 90,
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.black,
                    selectedTextColor: primaryColor,
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        selectedValue = date;
                      });
                      debugPrint("Selected date: ${selectedValue.toLocal()}");
                    },
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                height: 60,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: time,
                            accentColor: blackColor,
                            sunrise: TimeOfDay(hour: 6, minute: 0),
                            sunset: TimeOfDay(hour: 18, minute: 0),
                            duskSpanInMinutes: 120,
                            onChange: (Time value) {
                              setState(() {
                                time = value;
                                convertTimeOfDayToTime(value);
                              });

                              selectedTime = TimeOfDay(
                                  hour: value.hour, minute: value.minute);
                              debugPrint(
                                  "Selected Time: ${selectedTime!.format(context)}");
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 110,
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                MingCute.clock_line,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),
                              PrimaryText(
                                text: "Select Time",
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border.all(
                          width: 1,
                          color: Colors.black26,
                        ),
                      ),
                      child: Center(
                        child: PrimaryText(
                          text: "${time.format(context)}",
                          size: 12.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShowUpAnimation(
                                delay: 200,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  MingCute.receive_money_fill,
                                                  size: 35,
                                                  color: blackColor,
                                                ),
                                                TextUtil(
                                                  text: "Total Fee",
                                                  size: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    CediSign(
                                                      size: 22,
                                                      weight: FontWeight.bold,
                                                    ),
                                                    SizedBox(width: 2),
                                                    TextUtil(
                                                      text: "${totalCharged()}",
                                                      size: 22,
                                                      weight: true,
                                                    ),
                                                  ],
                                                ),
                                                TextUtil(
                                                  text: "Charges included",
                                                  size: 10,
                                                  color: iconGrey,
                                                ),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        TextUtil(
                                                          text: "LOCATION",
                                                          size: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: TextUtil(
                                                            text: widget
                                                                    .location ??
                                                                'NULL',
                                                            size: 13,
                                                            weight: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Transform.rotate(
                                              angle: 0,
                                              child: SizedBox(
                                                height: 150,
                                                width: 170,
                                                child: SvgPicture.asset(
                                                  "assets/svgs/undraw_barber_utly.svg",
                                                  // color: blackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              TextUtil(
                                                text: "APPOINTMENT DATE",
                                                size: 12,
                                              ),
                                              TextUtil(
                                                text:
                                                    '${selectedValue.day} - ${selectedValue.month} - ${selectedValue.year}',
                                                size: 15,
                                                weight: true,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              TextUtil(
                                                text: "SERVICE TYPE",
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: TextUtil(
                                                  text: widget.serviceType ??
                                                      'NULL',
                                                  size: 15,
                                                  weight: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              TextUtil(
                                                text: "APPOINTMENT TIME",
                                                size: 12,
                                              ),
                                              TextUtil(
                                                text:
                                                    "${time.format(context)}" ??
                                                        'Selected Time',
                                                size: 15,
                                                weight: true,
                                                //  color: Theme.of(context).primaryColor,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              TextUtil(
                                                text: "SHOP",
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: TextUtil(
                                                  text: widget.shop ?? 'SHOP',
                                                  size: 15,
                                                  weight: true,
                                                  //  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 1,
                                            child: Row(
                                              children: List.generate(
                                                700 ~/ 10,
                                                (index) => Expanded(
                                                  child: Container(
                                                    color: index % 2 == 0
                                                        ? Colors.transparent
                                                        : secondaryColor3,
                                                    height: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: -10,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: primaryColor,
                                    ),
                                  ),
                                  Positioned(
                                    right: -10,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              ShowUpAnimation(
                                delay: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          try {
                                            if (widget.serviceType != null ||
                                                widget.amount != null ||
                                                widget.location != null ||
                                                widget.id != null) {
                                              context
                                                  .read<AppointmentBloc>()
                                                  .add(
                                                    CreateAppointmentEvent(
                                                      shopName: widget.shop,
                                                      category: 'Male',
                                                      appointmentTime:
                                                          selectedTime,
                                                      appointmentDate:
                                                          selectedValue,
                                                      phone: widget.phone,
                                                      servicesType:
                                                          widget.serviceType,
                                                      amount: totalCharged(),
                                                      img: widget.imgurl,
                                                      location: widget.location,
                                                    ),
                                                  );
                                            } else {
                                              toast.errorToast(
                                                message:
                                                    'an unexpected error occured',
                                                alignment: Alignment.topCenter,
                                              );
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: blackColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          alignment: Alignment.center,
                                          child:
                                              state is AppointmentsLoadingState
                                                  ? SizedBox(
                                                      width: 22,
                                                      height: 22,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: whiteColor,
                                                      ),
                                                    )
                                                  : TextUtil(
                                                      text: "Book Now",
                                                      weight: true,
                                                      color: primaryColor,
                                                      size: 16,
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
