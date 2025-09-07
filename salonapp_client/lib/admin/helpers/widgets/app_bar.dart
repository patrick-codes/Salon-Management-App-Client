// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/presentation/authentication%20screens/bloc/auth_bloc.dart';

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
          avatarContainer(context),
          const SizedBox(width: 8),
          titleContainer(context),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/ownerappointment');
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
                  size: 25,
                ),
        ),
        SizedBox(width: 17),
      ],
    );
  }

  Widget avatarContainer(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, state) {
        if (state is CurrentUserState) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(
                    state.user?.profilePhoto ?? '',
                  ).image,
                ),
                color: Colors.black12,
                border: Border.all(
                  color: outlineGrey,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/account');
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(
                color: Colors.black26,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Icon(
                MingCute.user_5_line,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titleContainer(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 45,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.4),
          border: Border.all(
            width: 1.5,
            color: Colors.black26,
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
