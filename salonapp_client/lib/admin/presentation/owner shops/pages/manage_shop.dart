import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';

class ManageShopPage extends StatefulWidget {
  final String shopId; // will be documentId OR we can use ownerId query
  const ManageShopPage({Key? key, required this.shopId}) : super(key: key);

  @override
  State<ManageShopPage> createState() => _ManageShopPageState();
}

class _ManageShopPageState extends State<ManageShopPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String? shopImage;
  bool _isLoading = true;
  late DocumentReference shopRef;

  @override
  void initState() {
    super.initState();
    _loadShopDetails();
  }

  Future<void> _loadShopDetails() async {
    try {
      // Assuming widget.shopId is the Firestore document ID
      shopRef = FirebaseFirestore.instance
          .collection("salonshops")
          .doc(widget.shopId);

      final doc = await shopRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data["shopName"] ?? "";
          _locationController.text = data["location"] ?? "";
          _descController.text = data["openingDays"] != null
              ? "Open: ${data['openingDays']} - ${data['operningTimes']}"
              : "";
          _phoneController.text = data["phone"] ?? "";
          _whatsappController.text = data["whatsapp"] ?? "";
          shopImage = data["profileImg"];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shop not found!")),
        );
      }
    } catch (e) {
      debugPrint("Error loading shop: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateShop() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await shopRef.update({
        "shopName": _nameController.text.trim(),
        "location": _locationController.text.trim(),
        "openingDays": _descController.text.trim(),
        "phone": _phoneController.text.trim(),
        "whatsapp": _whatsappController.text.trim(),
        "profileImg": shopImage, // keep existing if not changed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shop updated successfully!")),
      );
    } catch (e) {
      debugPrint("Error updating shop: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update shop.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Shop"),
        backgroundColor: Colors.black87,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Shop Image
                    GestureDetector(
                      onTap: () {
                        // TODO: open image picker and upload to Firebase Storage
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          shopImage ?? "https://via.placeholder.com/300",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Shop Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Shop Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter shop name" : null,
                    ),
                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter location" : null,
                    ),
                    const SizedBox(height: 16),

                    // Opening Days + Times (merged in description field for now)
                    TextFormField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Opening Days & Times",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter phone number"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Whatsapp
                    TextFormField(
                      controller: _whatsappController,
                      decoration: const InputDecoration(
                        labelText: "WhatsApp Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: _updateShop,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Update Shop",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
