import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helpers/colors/color_constants.dart';
import '../repository/data rmodel/h_shop_service_model.dart';

class GridViewComponent extends StatelessWidget {
  List<HomeShopModel>? shops;
  GridViewComponent({
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
            child: Container(
              width: 120,
              height: 170,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: shops![index].profileImg ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                            color: Colors.white,
                            // color: const Color.fromARGB(
                            //   255, 233, 248, 255),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          // child: Column(
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       children: [
                          //         Container(
                          //           height: 18,
                          //           width: 18,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(20),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 blurRadius: 2,
                          //                 spreadRadius: 1,
                          //                 color: Colors.grey.withOpacity(0.5),
                          //               ),
                          //             ],
                          //           ),
                          //           child: const Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: [
                          //               Icon(
                          //                 Icons.favorite_border_outlined,
                          //                 color: Colors.red,
                          //                 size: 12,
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[200]!,
                            child: Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: secondaryColor3,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 40,
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: const Icon(
                                Icons.error,
                                color: iconGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    shops![index].shopName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          wordSpacing: 2,
                                          //color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  shops![index].location.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: secondaryColor3,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  shops![index].openingDays.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: blackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 80,
                    right: 5,
                    child: Container(
                      height: 17,
                      width: 50,
                      decoration: BoxDecoration(
                          color: shops![index].isOpened == true
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text(
                          shops![index].isOpened == true ? "Open" : "Closed",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
