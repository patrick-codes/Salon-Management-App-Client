import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:flutter/material.dart';
import '../../../helpers/colors/color_constants.dart';
import '../components/Transaction/other/data/flight_data.dart';
import '../components/Transaction/other/show_up_animation.dart';
import '../components/Transaction/other/text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String process = "Pay";
  CurrencyCode selectedCurrency = CurrencyCode.GHS;
  String symbol = "₵";
  @override
  Widget build(BuildContext context) {
    print("GHS ${symbol}");

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            height: 60,
            alignment: Alignment.centerLeft,
            child: TextUtil(
              text: "Checkout",
              weight: true,
              size: 20,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowUpAnimation(
                          delay: 200,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                          TextUtil(
                                            text:
                                                "$symbol ${flightList[0].price}",
                                            size: 22,
                                            weight: true,
                                            //color: Theme.of(context).primaryColor,
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
                                          text: "FLIGHT DATE",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].date,
                                          size: 15,
                                          weight: true,
                                          // color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextUtil(
                                          text: "GATE",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].gate,
                                          size: 15,
                                          weight: true,
                                          // color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextUtil(
                                          text: "FLIGHT NO",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].flightNo,
                                          size: 15,
                                          weight: true,
                                          //  color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    )
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
                                          text: "BOARDING TIME",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].boardingTime,
                                          size: 15,
                                          weight: true,
                                          //  color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextUtil(
                                          text: "SEAT",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].seat,
                                          size: 15,
                                          weight: true,
                                          //  color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        TextUtil(
                                          text: "CLASS",
                                          size: 12,
                                        ),
                                        TextUtil(
                                          text: flightList[0].flightClass,
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
                              Center(
                                  child: TextUtil(
                                text: "Check Out Now",
                                // color: Theme.of(context).primaryColor,
                                weight: true,
                              )),
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
                                                ? "Pay Now"
                                                : "Appointment Booked",
                                            weight: true,
                                            color: whiteColor,
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
        ],
      ),
    );
  }

  void update() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        process = "Book";
      });
    });
  }
}
