import 'package:flutter/widgets.dart';

import '../color_constants.dart';

class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;
  final TextAlign alignment;
  final TextOverflow textOverflow;
  const PrimaryText(
      {super.key,
      this.size = 20,
      this.fontWeight = FontWeight.w400,
      this.color = primaryColor,
      required this.text,
      this.height = 1.3,
      this.textOverflow = TextOverflow.visible,
      this.alignment = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.visible,
      text,
      textAlign: alignment,
      style: TextStyle(
        color: color,
        height: height,
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
