import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import '../../../helpers/colors/widgets/custom_button.dart';
import '../../checkout page/components/cedi_sign_component.dart';
import '../repository/receipt/receipt_service.dart';

class ReceiptPage extends StatefulWidget {
  final String id;
  final String name;
  final String datetime;
  final double amount;
  final String receiptId;
  final String phone;
  final String service;
  const ReceiptPage({
    Key? key,
    required this.id,
    required this.name,
    required this.datetime,
    required this.amount,
    required this.receiptId,
    required this.phone,
    required this.service,
  }) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/mainhome', (Route<dynamic> route) => false);
          },
          child: Icon(
            MingCute.home_4_line,
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Receipt ",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "${widget.receiptId}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              MingCute.share_forward_line,
            ),
          ),
          SizedBox(width: 17),
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
              icon: MingCute.pdf_line,
              text: ' Download Receipt',
              onpressed: () => ReceiptService.downloadReceiptAsPDF(),
              color: blackColor,
            ),
          ),
        ),
      ),
      backgroundColor: secondaryBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                RepaintBoundary(
                  key: ReceiptService.receiptKey,
                  child: DottedBorder(
                    strokeWidth: 1,
                    dashPattern: const [6, 4],
                    color: iconGrey,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
                    child: Container(
                      height: 540,
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
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
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/play_store_512.png",
                                    height: 130,
                                    width: 130,
                                  ),
                                  Text(
                                    "Hairvana Salon Booking",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    "Tanoso-Kumasi Ghana",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black54,
                                        ),
                                  ),
                                  Text(
                                    "+233 245-523-607",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                Text(
                                  widget.phone,
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
                                  "Service Fee",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                ),
                                Row(
                                  children: [
                                    CediSign(
                                      size: 13.5,
                                      weight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      " ${ReceiptService.total(widget.amount)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Extra Charges",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                ),
                                Row(
                                  children: [
                                    CediSign(
                                      size: 13.5,
                                      weight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      " 2.0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date & Time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                ),
                                Text(
                                  widget.datetime,
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
                                  "Service Type",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                ),
                                Text(
                                  widget.service,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Colors.red,
                                          decorationStyle:
                                              TextDecorationStyle.wavy),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.4),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Receipt ID: ${widget.receiptId}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FlutterClipboard.copy(
                                              "${widget.receiptId}")
                                          .then(
                                        (value) => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            clipBehavior: Clip.none,
                                            width: 255,
                                            content: Text(
                                                style: TextStyle(fontSize: 12),
                                                "Receipt ID: ${widget.receiptId} Copied"),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 20,
                                      weight: 8,
                                      grade: 8,
                                      opticalSize: 8,
                                      color: iconGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.verified_user,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 273,
                                  child: Column(
                                    children: [
                                      Text(
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        "No additional fee or taxes will be collected by the salon/barbershop owner when you arrive at the shop.",
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
                            const SizedBox(height: 20),
                            const Divider(
                              height: 5,
                            ),
                            const SizedBox(height: 8),
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
                                Row(
                                  children: [
                                    CediSign(
                                      size: 16,
                                      weight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      " ${widget.amount}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
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
