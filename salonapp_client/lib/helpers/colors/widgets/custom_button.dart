// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../color_constants.dart';

class CustomButton extends StatelessWidget {
  String text;
  final void Function() onpressed;
  Color color;
  CustomButton({
    Key? key,
    required this.text,
    required this.onpressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: secondaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
