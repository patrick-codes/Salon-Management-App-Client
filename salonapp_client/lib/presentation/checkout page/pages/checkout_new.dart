import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/style.dart';
import '../../../helpers/colors/color_constants.dart';
import '../components/Transaction/other/data/flight_data.dart';
import '../components/Transaction/other/show_up_animation.dart';
import '../components/Transaction/other/text.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/cedi_sign_component.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String process = "Pay";
  CurrencyCode selectedCurrency = CurrencyCode.GHS;

  late DateTime selectedValue = DateTime.now();
  Time time = Time(hour: DateTime.now().hour, minute: DateTime.now().minute);

  void update() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        process = "Book";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_outlined,
              //color: Theme.of(context).canvasColor,
            )),
        backgroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                debugPrint("Selected date: ${selectedValue!.toLocal()}");
              },
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
                        sunrise: TimeOfDay(hour: 6, minute: 0),
                        sunset: TimeOfDay(hour: 18, minute: 0),
                        duskSpanInMinutes: 120,
                        onChange: (value) {
                          setState(() {
                            time = value;
                          });
                          debugPrint("Selected Time: ${time.format(context)}");
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 35,
                    width: 110,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(66, 111, 111, 111),
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
                          ),
                          SizedBox(width: 3),
                          PrimaryText(
                            text: "Select Time",
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 5),
                Container(
                  height: 35,
                  width: 110,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(66, 111, 111, 111),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(width: 1, color: iconGrey),
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
                  color: blackColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30))),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                          bottom: Radius.circular(20))),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.asset(
                                                "assets/pngs/play_store_512.png",
                                              ),
                                            ),
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 35,
                                              color: Theme.of(context)
                                                  .indicatorColor,
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
                                                  text:
                                                      "${flightList[0].price}",
                                                  size: 22,
                                                  weight: true,
                                                  //color: Theme.of(context).primaryColor,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: 0,
                                          child: SizedBox(
                                            height: 150,
                                            width: 190,
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
                                                '${selectedValue.day} - ${selectedValue.month} - ${selectedValue!.year}',
                                            size: 15,
                                            weight: true,
                                            // color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          TextUtil(
                                            text: "SERVICE TYPE",
                                            size: 12,
                                          ),
                                          TextUtil(
                                            text: "SHAVING",
                                            size: 15,
                                            weight: true,
                                            //  color: Theme.of(context).primaryColor,
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
                                            text: "${time.format(context)}" ??
                                                'Selected Time',
                                            size: 15,
                                            weight: true,
                                            //  color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                      // Column(
                                      //   children: [
                                      //     TextUtil(
                                      //       text: "SEAT",
                                      //       size: 12,
                                      //     ),
                                      //     TextUtil(
                                      //       text: flightList[0].seat,
                                      //       size: 15,
                                      //       weight: true,
                                      //       //  color: Theme.of(context).primaryColor,
                                      //     ),
                                      //   ],
                                      // ),

                                      Column(
                                        children: [
                                          TextUtil(
                                            text: "SHOP",
                                            size: 12,
                                          ),
                                          TextUtil(
                                            text: "Toronto HairCuts",
                                            size: 15,
                                            weight: true,
                                            //  color: Theme.of(context).primaryColor,
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
                                  backgroundColor: blackColor,
                                ),
                              ),
                              Positioned(
                                right: -10,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: blackColor,
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
                                      setState(() {
                                        process = "Load";
                                        update();
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: blackColor,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      alignment: Alignment.center,
                                      child: process == "Load"
                                          ? SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: whiteColor,
                                              ),
                                            )
                                          : TextUtil(
                                              text: process == "Pay"
                                                  ? "Book Now"
                                                  : "Appointment Booked",
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
  }
}
