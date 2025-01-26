import 'package:flutter/material.dart';
import '../color_constants.dart';

class MinimalHeadingText extends StatelessWidget {
  String leftText;
  String rightText;
  MinimalHeadingText({
    Key? key,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
        ),
        Text(
          rightText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
