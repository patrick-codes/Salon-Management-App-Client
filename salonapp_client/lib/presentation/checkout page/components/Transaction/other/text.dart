import 'package:flutter/material.dart';
import '../../../../../helpers/colors/color_constants.dart';

class TextUtil extends StatelessWidget {
  String text;
  Color? color;
  double? size;
  bool? weight;
  TextOverflow? textoverflow;
  TextUtil({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
    this.textoverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow:
          textoverflow == null ? TextOverflow.visible : TextOverflow.visible,
      style: TextStyle(
          color: color ?? blackColor,
          fontSize: size ?? 18,
          fontWeight: weight == null ? FontWeight.normal : FontWeight.bold),
    );
  }
}
