import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:salonapp_client/presentation/shops/repository/data%20rmodel/service_model.dart';
import '../../authentication screens/bloc/auth_bloc.dart';
import '../bloc/shops_bloc.dart';
import '../components/createservice_controllers.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final controller = CreateShopController();
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  final List<String> categories = ["Unisex", "Men", "Women"];
  final List<String> openingDaysList = [
    "Mondays - Saturdays",
    "Tuesdays - Sundays",
    "All Week"
  ];
  final List<String> openingTimesList = [
    "8:30am - 9:30pm",
    "9:00am - 8:00pm",
    "10:00am - 7:00pm"
  ];

  String? selectedCategory;
  String? selectedDays;
  String? selectedTimes;
  List<Service> services = [];
  List<String> workImageUrls = [];
  String? profileImageUrl;

  File? _profileImage;
  List<File> _workImages = [];

  final serviceNameController = TextEditingController();
  final servicePriceController = TextEditingController();

  String _formatDateHuman(DateTime date) {
    final day = date.day;
    final suffix = (day >= 11 && day <= 13)
        ? 'th'
        : (day % 10 == 1)
            ? 'st'
            : (day % 10 == 2)
                ? 'nd'
                : (day % 10 == 3)
                    ? 'rd'
                    : 'th';
    final month = DateFormat('MMMM').format(date);
    return '$day$suffix $month ${date.year}';
  }

  void _addService() {
    final name = serviceNameController.text.trim();
    final price = double.tryParse(servicePriceController.text.trim());

    if (name.isNotEmpty && price != null) {
      setState(() {
        services.add(Service(name: name, price: price)); // 👈 Use Service
      });
      serviceNameController.clear();
      servicePriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopsBloc, ShopsState>(
      listener: (context, state) {
        if (state is ImagePickedState) {
          setState(() {
            _profileImage = state.pickedFile;
            profileImageUrl = state.imageUrl;
          });
        } else if (state is WorkImagesPickedState) {
          setState(() {
            _workImages = state.imageUrls.map((path) => File(path)).toList();
          });
        }
        if (state is LocalImagesPickedState) {
          setState(() {
            _workImages = state.pickedFiles;
          });
        }

        if (state is ShopCreatedSuccesState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ShopCreateFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is AuthLogoutSuccesState) {
          Navigator.pushNamed(context, '/');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Shop"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Shop Name
                    _buildTextField(
                      controller: CreateShopController.shopName,
                      label: "Shop Name",
                      validator: (v) =>
                          v!.isEmpty ? "Please enter shop name" : null,
                    ),
                    const SizedBox(height: 16),

                    // Category
                    _buildDropdown(
                      label: "Category",
                      value: selectedCategory,
                      items: categories,
                      onChanged: (val) =>
                          setState(() => selectedCategory = val),
                    ),
                    const SizedBox(height: 16),

                    // Opening Days
                    _buildDropdown(
                      label: "Opening Days",
                      value: selectedDays,
                      items: openingDaysList,
                      onChanged: (val) => setState(() => selectedDays = val),
                    ),
                    const SizedBox(height: 16),

                    // Opening Times
                    _buildDropdown(
                      label: "Opening Times",
                      value: selectedTimes,
                      items: openingTimesList,
                      onChanged: (val) => setState(() => selectedTimes = val),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    _buildTextField(
                      controller: CreateShopController.location,
                      label: "Location",
                      validator: (v) =>
                          v!.isEmpty ? "Please enter location" : null,
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    _buildTextField(
                      controller: CreateShopController.phone,
                      label: "Phone",
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v!.isEmpty ? "Please enter phone number" : null,
                    ),
                    const SizedBox(height: 16),

                    // WhatsApp
                    _buildTextField(
                      controller: CreateShopController.whatsapp,
                      label: "WhatsApp (optional)",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),

                    // Services with Price
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Services",
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: serviceNameController,
                            label: "Service",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: servicePriceController,
                            label: "Price",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: _addService,
                        )
                      ],
                    ),
                    if (services.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: services
                            .map((s) => Chip(
                                  label: Text("${s.name} - \$${s.price}"),
                                  onDeleted: () => setState(() {
                                    services.remove(s);
                                  }),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 24),

                    // Profile Image
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ShopsBloc>().add(PickProfileImageEvent());
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Pick Profile Image"),
                    ),
                    const SizedBox(height: 16),

                    // Work Images
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ShopsBloc>().add(PickShopImageEvent());
                      },
                      icon: const Icon(Icons.collections),
                      label: const Text("Pick Work Images"),
                    ),
                    const SizedBox(height: 16),

                    if (profileImageUrl != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profileImageUrl!),
                      ),

                    if (_workImages.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _workImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _workImages[i],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    state is ShopsLoadingState
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ShopsBloc>().add(
                                      CreateShopEvent(
                                        shopOwnerId: firebaseUser,
                                        shopName: CreateShopController
                                            .shopName.text
                                            .trim(),
                                        category: selectedCategory!,
                                        openingDays: selectedDays!,
                                        operningTimes: selectedTimes!,
                                        location: CreateShopController
                                            .location.text
                                            .trim(),
                                        phone: CreateShopController.phone.text
                                            .trim(),
                                        whatsapp: CreateShopController
                                            .whatsapp.text
                                            .trim(),
                                        services: services,

                                        profileImgFile:
                                            _profileImage, // 👈 file for uploading
                                        profileImg: profileImageUrl,

                                        workImgFiles: _workImages,
                                        dateJoined:
                                            _formatDateHuman(DateTime.now()),
                                        isOpen: true,
                                      ),
                                    );
                              }
                            },
                            child: const Text("Submit"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      validator: (val) => val == null ? "Please select $label" : null,
    );
  }
}
