// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomAppBar extends StatelessWidget {
  int? count;
  CustomAppBar({
    Key? key,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 10,
      title: Row(
        children: [
          avatarContainer(),
          const SizedBox(width: 8),
          titleContainer(context),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/appointment');
          },
          child: count != null && count! > 0
              ? Badge(
                  label: Text("$count"),
                  smallSize: 5,
                  child: Icon(
                    MingCute.notification_line,
                    color: Colors.black87,
                  ),
                )
              : Icon(
                  MingCute.notification_line,
                  color: Colors.black87,
                ),
        ),
        SizedBox(width: 17),
      ],
    );
  }

  Container avatarContainer() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Icon(
          MingCute.user_5_line,
        ),
      ),
    );
  }

  Widget titleContainer(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 35,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.4),
          border: Border.all(
            width: 1,
            color: Colors.grey.shade400.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Admin Dashboard",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
