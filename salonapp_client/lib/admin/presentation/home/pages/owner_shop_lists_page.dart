import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/helpers/widgets/text_widgets.dart';
import '../../../../presentation/shops/repository/data rmodel/service_model.dart';
import '../../../helpers/constants/color_constants.dart';
import '../../owner shops/bloc/owner_shops_bloc.dart';
import 'ownershop_details_page.dart';

class OwnerShopsListPage extends StatelessWidget {
  const OwnerShopsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;

    // Trigger fetch when page is opened
    context.read<OwnerShopsBloc>().add(FetchOwnerShopEvent(ownerId: ownerId));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: headingTextMedium(
          context,
          'My shops',
          FontWeight.w600,
          15,
          whiteColor,
        ),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<OwnerShopsBloc, OwnerShopsState>(
        builder: (context, state) {
          if (state is OwnerShopLoading || state is OwnerShopsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OwnerShopFailure) {
            return Center(child: Text(state.error));
          } else if (state is OwnerShopLoaded) {
            final shop = state.shop;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildShopCard(context, shop),
              ],
            );
          } else if (state is OwnerShopsFetchedState) {
            final shops = state.shop ?? [];

            if (shops.isEmpty) {
              return const Center(
                  child: Text("You haven’t created any shops yet."));
            }

            return ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                return _buildShopCard(context, shops[index]);
              },
            );
          }

          return const Center(child: Text("No data found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, "/createshop");
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildShopCard(BuildContext context, ShopModel shop) {
    return Card(
      color: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              shop.profileImg != null && shop.profileImg!.isNotEmpty
                  ? NetworkImage(shop.profileImg!)
                  : const AssetImage("assets/images/placeholder.png")
                      as ImageProvider,
        ),
        title: Text(
          shop.shopName ?? "Unnamed Shop",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shop.category ?? ""),
            Text("📍 ${shop.location ?? ''}"),
            Text("☎ ${shop.phone ?? ''}"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: iconGrey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShopDetailsPage(shop: shop),
            ),
          );
        },
      ),
    );
  }
}
