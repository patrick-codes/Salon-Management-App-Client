import 'package:flutter/material.dart';
import '../../../../helpers/colors/color_constants.dart';
import '../../../../helpers/widgets/text_widgets.dart';
import '../../../../presentation/shops/repository/data rmodel/service_model.dart';

class ShopDetailsPage extends StatelessWidget {
  final ShopModel shop;

  const ShopDetailsPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: headingTextMedium(
          context,
          shop.shopName ?? "Shop Details",
          FontWeight.w600,
          15,
          whiteColor,
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    shop.profileImg != null && shop.profileImg!.isNotEmpty
                        ? NetworkImage(shop.profileImg!)
                        : const AssetImage("assets/images/placeholder.png")
                            as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),

            // Shop Info
            Text(
              shop.shopName ?? "Unnamed Shop",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Category: ${shop.category ?? 'N/A'}"),
            const SizedBox(height: 4),
            Text("Location: ${shop.location ?? 'N/A'}"),
            const SizedBox(height: 4),
            Text("Phone: ${shop.phone ?? 'N/A'}"),
            const SizedBox(height: 4),
            Text("Regstration Date: ${shop.dateJoined ?? 'No description'}"),

            const SizedBox(height: 24),

            // Services (if available)
            if (shop.services != null && shop.services!.isNotEmpty) ...[
              const Text(
                "Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: shop.services!.map((service) {
                  return Card(
                    color: whiteColor,
                    elevation: 0.5,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(service.name ?? "Service"),
                      subtitle: Text("Price: ${service.price ?? 'N/A'}"),
                    ),
                  );
                }).toList(),
              ),
            ] else
              const Text("No services added yet."),

            // const SizedBox(height: 30),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         Navigator.pushNamed(
            //           context,
            //           "/editShop",
            //           arguments: shop,
            //         );
            //       },
            //       icon: const Icon(Icons.edit),
            //       label: const Text("Edit"),
            //       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            //     ),
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         // TODO: Implement delete shop
            //       },
            //       icon: const Icon(Icons.delete),
            //       label: const Text("Delete"),
            //       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
