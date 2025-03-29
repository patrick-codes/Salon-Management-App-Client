// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CediSign extends StatelessWidget {
  double? size;
  FontWeight? weight;
  CediSign({
    Key? key,
    this.size,
    this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "₵",
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
