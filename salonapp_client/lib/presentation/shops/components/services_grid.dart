import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../helpers/colors/color_constants.dart';
import '../../../helpers/colors/widgets/style.dart';
import '../repository/data rmodel/h_shop_service_model.dart';

class ServiceGridViewComponent extends StatelessWidget {
  List<HomeShopModel>? shops;
  ServiceGridViewComponent({
    required this.shops,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          mainAxisExtent: 170,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shops!.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/mainshopinfo',
                arguments: {
                  'id': shops![index].shopId,
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 125,
                  width: 115,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryText(
                              text: "prices",
                              size: 15,
                              color: Colors.red[500]!,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "services",
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
