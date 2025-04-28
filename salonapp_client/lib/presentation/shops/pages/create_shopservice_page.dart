import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/authentication%20screens/bloc/auth_bloc.dart';
import 'package:salonapp_client/presentation/shops/bloc/shops_bloc.dart';

import '../components/createservice_controllers.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final controller = CreateShopController();
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopsBloc, ShopsState>(
      listener: (BuildContext context, state) {
        if (state is ShopCreatedSuccesState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ShopCreateFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                    child: Text("add serviceman"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        height: 355,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: const BoxDecoration(
                            // color: Colors.red,
                            ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.shopName,
                              decoration: InputDecoration(
                                hintText: 'Shop Name',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.category,
                              decoration: InputDecoration(
                                hintText: 'Category',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.openingDays,
                              decoration: InputDecoration(
                                hintText: 'Opening Days',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.location,
                              decoration: InputDecoration(
                                hintText: 'Location',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 355,
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: const BoxDecoration(
                            //color: Colors.blue,
                            ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.phone,
                              decoration: InputDecoration(
                                hintText: 'Contact',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              readOnly: true,
                              controller: CreateShopController.profileImg,
                              onTap: () {
                                context.read<AuthBloc>().add(PickImageEvent());
                              },
                              decoration: InputDecoration(
                                hintText: 'Image',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.services,
                              decoration: InputDecoration(
                                hintText: 'Services',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: CreateShopController.whatsapp,
                              decoration: InputDecoration(
                                hintText: 'Whatsapp',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: CreateShopController.dateJoined,
                          decoration: InputDecoration(
                            hintText: 'Date joined',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              context.read<ShopsBloc>().add(
                                    CreateShopEvent(
                                      shopOwnerId: firebaseUser,
                                      shopName:
                                          CreateShopController.shopName.text,
                                      category:
                                          CreateShopController.category.text,
                                      openingDays:
                                          CreateShopController.openingDays.text,
                                      operningTimes: CreateShopController
                                          .operningTimes.text,
                                      location:
                                          CreateShopController.location.text,
                                      phone: CreateShopController.phone.text,
                                      whatsapp:
                                          CreateShopController.whatsapp.text,
                                      services:
                                          CreateShopController.services.text,
                                      profileImg:
                                          CreateShopController.profileImg.text,
                                      dateJoined:
                                          CreateShopController.dateJoined.text,
                                      isOpen: true,
                                    ),
                                  );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Submit"),
                              ],
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  state is ShopsLoadingState
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator())
                      : SizedBox.shrink(),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
