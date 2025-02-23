import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/custom_button.dart';

import '../../../helpers/colors/color_constants.dart';

class CheckoutPage extends StatefulWidget {
  final String? title;
  final int? quantity;
  final double? amount;
  final String? img;
  const CheckoutPage({
    Key? key,
    required this.title,
    required this.quantity,
    required this.amount,
    required this.img,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final int _addCart = 0;
  double? _amount;
  final String ref = '${DateTime.now()}25';
  final String _currency = 'GHS';
  final String _email = 'kofiktechgh@gmail.com';
  final String _accesscode = '233455';
  double weightFee = 90;
  double shippingFee = 200;
  double? total = 0.0;

  // final plugin = PaystackPlugin();
  String message = '';

  // @override
  // void initState() {
  //   plugin.initialize(publicKey: ApiKeys.publicKey);
  //   getTotal();
  //   super.initState();
  // }

  // void makePayment() async {
  //   _amount = total;
  //   double price = _amount! * 100;
  //   Charge charge = Charge()
  //     // ..accessCode = _accesscode
  //     ..amount = price.toInt()
  //     ..reference = ref
  //     ..email = _email
  //     ..currency = _currency;

  //   CheckoutResponse response = await plugin.checkout(
  //     context,
  //     logo: Image.asset(
  //       "assets/images/logo.jpg",
  //       height: 60,
  //       width: 60,
  //     ),
  //     charge: charge,
  //     method: CheckoutMethod.card,
  //   );
  //   if (response.status == true) {
  //     message = '${response.reference}';
  //     print(message);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SucessPage(message: message),
  //       ),
  //     );

  //     // DialogBoxUtil(
  //     //   context,
  //     //   onTap: () {},
  //     //   content: '',
  //     //   leftText: '',
  //     //   rightText: '',
  //     //   oncancel: () {},
  //     //   icon: Icons.done,
  //     // );
  //   } else {
  //     print("access code error");
  //   }
  // }

  Future getTotal() async {
    setState(() {
      total = shippingFee + weightFee + widget.amount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        leading: const Icon(
          MingCute.arrow_left_fill,
        ),
        centerTitle: true,
        title: Text(
          "Book Appointment",
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
      bottomNavigationBar: Container(
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
            child: CustomButton(
              text: 'Checkout',
              onpressed: () {},
              color: Colors.green,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 350,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    border: Border.all(width: 1, color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "APPOINTMENT REVIEW",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "GHC 30.00",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 140,
                  padding: const EdgeInsets.all(15),
                  width: 350,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(widget.img ?? ''),
                                //image: NetworkImage(widget.img ?? ''),
                              ),
                              //color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Container(
                            height: 105,
                            width: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    maxLines: 2,
                                    widget.title ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Date & Time",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        MingCute.calendar_line,
                                        size: 15,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        "Monday 24, February 2025",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(
                                        MingCute.time_line,
                                        size: 15,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        "12:30 PM Afternoon",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                DottedBorder(
                  strokeWidth: 1,
                  dashPattern: const [6, 4],
                  color: primaryColor,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(5),
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(15),
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          color: Color.fromARGB(255, 234, 233, 233),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shipping Weight",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                            ),
                            Text(
                              "GHS $weightFee",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                            ),
                            Text(
                              "GHS ${widget.amount}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shipping & Handling",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                            ),
                            Text(
                              "GHS $shippingFee",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customs/imports/duties/taxes",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                            ),
                            Text(
                              "Not included",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.red),
                            ),
                          ],
                        ),

                        ///
                        const SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_box_outline_blank_outlined,
                                color: Colors.black45),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 273,
                              child: Column(
                                children: [
                                  Text(
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    "I agree that customs and import Duties & Taxes will be collected by the courier company at the time of delivery.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Divider(
                          height: 5,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "GHS $total",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(
                          height: 5,
                        ),
                      ],
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
}
