import 'package:flutter/material.dart';
import '../colors/color_constants.dart';

class DialogBoxUtil extends StatelessWidget {
  const DialogBoxUtil(
    BuildContext context, {
    super.key,
    required this.onTap,
    required this.content,
    required this.leftText,
    required this.rightText,
    required this.oncancel,
    required this.icon,
  });
  final IconData icon;
  final String content;
  final String leftText;
  final String rightText;
  final void Function() onTap;
  final void Function() oncancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
          bottom: Radius.circular(8),
        ),
      ),
      content: Container(
        height: 270,
        width: 90,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
          // gradient: const LinearGradient(
          //   colors: [
          //     primaryColor,
          //     backgroundColorDeep2,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.topRight,
          // ),
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                // gradient: LinearGradient(
                //   colors: [
                //     primaryColor,
                //     backgroundColorDeep2,
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.topRight,
                // ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: secondaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      content,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: oncancel,
                            child: Text(
                              leftText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onTap,
                            child: Text(
                              rightText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
