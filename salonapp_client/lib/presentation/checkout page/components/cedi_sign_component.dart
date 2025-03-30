// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CediSign extends StatelessWidget {
  double? size;
  FontWeight? weight;
  Color? color;
  CediSign({
    Key? key,
    this.size,
    this.weight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "₵",
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: weight,
        color: color ==null?Colors.black:color,
      ),
    );
  }
}
