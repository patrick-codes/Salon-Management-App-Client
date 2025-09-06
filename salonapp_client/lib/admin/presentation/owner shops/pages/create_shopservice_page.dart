import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:salonapp_client/presentation/authentication%20screens/bloc/auth_bloc.dart';
import '../../../helpers/config/size_config.dart';
import '../../../helpers/constants/color_constants.dart';
import '../../../helpers/text style/text_style.dart';
import '../bloc/owner_shops_bloc.dart';
import '../components/createservice_controllers.dart';
import '../repository/data rmodel/service_model.dart';

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
  List<OwnerService> services = [];
  List<String> workImageUrls = [];
  String? profileImageUrl;
  bool? isLoading;
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
        services.add(OwnerService(name: name, price: price));
      });
      serviceNameController.clear();
      servicePriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerShopsBloc, OwnerShopsState>(
      listener: (context, state) {
        if (state is OwnerImagePickedState) {
          setState(() {
            _profileImage = state.pickedFile;
            profileImageUrl = state.imageUrl;
          });
        } else if (state is OwnerWorkImagesPickedState) {
          setState(() {
            _workImages = state.imageUrls.map((path) => File(path)).toList();
          });
        }
        if (state is OwnerLocalImagesPickedState) {
          setState(() {
            _workImages = state.pickedFiles;
          });
        }

        if (state is OwnerShopCreatedSuccesState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pushNamed(context, '/ownerhome');
        } else if (state is OwnerShopCreateFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is AuthLogoutSuccesState) {
          Navigator.pushNamed(context, '/');
        }
        // else if (state is ProfileImageLoadingState) {}
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0.5,
            shadowColor: Colors.grey.shade100,
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
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<OwnerShopsBloc>()
                            .add(OwnerPickProfileImageEvent());
                      },
                      child: Container(
                        height: 182,
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(profileImageUrl ??
                                'https://unsplash.com/photos/barber-shop-tools-on-old-wooden-background-cCRNOTyXl18'),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 0.5,
                              color: Color.fromARGB(255, 234, 233, 233),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: profileImageUrl == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      MingCute.camera_2_fill,
                                      color: Colors.black54,
                                      size: 50,
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 273,
                                      child: Column(
                                        children: [
                                          Text(
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            "Upload a clear profile picture for your shop.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
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
                      label: "WhatsApp",
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
                            label: "OwnerService",
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
                                  side: BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                  label: Text("${s.name} - \GHS${s.price}"),
                                  onDeleted: () => setState(() {
                                    services.remove(s);
                                  }),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 24),

                    // Work Images
                    GestureDetector(
                      onTap: () {
                        context
                            .read<OwnerShopsBloc>()
                            .add(OwnerPickShopImageEvent());
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MingCute.photo_album_line,
                                size: 18,
                                color: iconGrey,
                              ),
                              SizedBox(width: 5),
                              PrimaryText(
                                text: 'Pick work images',
                                size: 13,
                                color: iconGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

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
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<OwnerShopsBloc>().add(
                                OwnerCreateShopEvent(
                                  shopOwnerId: firebaseUser,
                                  shopName:
                                      CreateShopController.shopName.text.trim(),
                                  category: selectedCategory!,
                                  openingDays: selectedDays!,
                                  operningTimes: selectedTimes!,
                                  location:
                                      CreateShopController.location.text.trim(),
                                  phone: CreateShopController.phone.text.trim(),
                                  whatsapp:
                                      CreateShopController.whatsapp.text.trim(),
                                  services: services,

                                  profileImgFile:
                                      _profileImage, // 👈 file for uploading
                                  profileImg: profileImageUrl,

                                  workImgFiles: _workImages,
                                  dateJoined: _formatDateHuman(DateTime.now()),
                                  isOpen: true,
                                ),
                              );
                        }
                      },
                      child: Container(
                        height: 55,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: state is OwnerShopsLoadingState
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: const CircularProgressIndicator(
                                        color: tertiaryColor,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                    SizedBox(width: 7),
                                    PrimaryText(
                                      text: 'Creating your shop....',
                                      size: 14,
                                      color: tertiaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrimaryText(
                                      text: 'Create Your Shop',
                                      size: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                        ),
                      ),
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

  Container avatarContainer() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(
          width: 1,
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Icon(
          MingCute.scissors_line,
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
          color: Colors.black12,
          border: Border.all(
            width: 1,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Shop",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
            ),
          ],
        ),
      ),
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
        fillColor: Colors.grey.shade200,
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 15,
          color: Colors.black54,
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
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
      isDense: true,
      items:
          items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      alignment: AlignmentDirectional.center,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade200),
      validator: (val) => val == null ? "Please select $label" : null,
    );
  }
}
