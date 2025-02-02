// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/widgets/custom_button.dart';

import '../../../helpers/colors/color_constants.dart';

class SucessPage extends StatefulWidget {
  final String message;
  SucessPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<SucessPage> createState() => _SucessPageState();
}

class _SucessPageState extends State<SucessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Checkout Complete",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  overflow: TextOverflow.visible,
                  "",
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor,
                  ),
                ),
                Text(
                  overflow: TextOverflow.visible,
                  widget.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
              ),
              const Text(
                "Payment sucessfully made with reference",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
                widget.message,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: CustomButton(
                    text: 'Home',
                    onpressed: () {
                      Navigator.pushReplacementNamed(context, '/mainhome');
                    },
                    color: Colors.green),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Report an issue",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
