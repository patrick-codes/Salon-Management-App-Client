import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import 'package:salonapp_client/helpers/colors/widgets/minimal_heading.dart';
import '../../../helpers/colors/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedService;
  String? selectedGender;
  String? selectedPrice;
  double selectedDistance = 10;

  final List<Icon> icons = const [
    Icon(MingCute.scissors_line),
    Icon(MingCute.hair_line),
    Icon(MingCute.sob_fill),
    Icon(MingCute.brush_line),
    Icon(MingCute.hair_line),
    Icon(MingCute.sob_fill),
  ];

  final List<String> services = [
    "Haircuts",
    "Shaves",
    "Dyeing",
    "Shampoo",
    "Locking",
    "Natural",
  ];

  final List<String> genders = [
    "Woman",
    "Man",
    "Other",
  ];

  final List<String> prices = [
    "GHC 20",
    "GHC 30",
    "GHC 50",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Filter",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MinimalHeadingText(leftText: "Services", rightText: ''),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: icons.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return buildCategoryCircle(
                      context, icons[index], services[index]);
                },
              ),
            ),

            const SizedBox(height: 25),

            // Gender
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MinimalHeadingText(leftText: "Gender", rightText: ''),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 35,
              child: ListView.builder(
                itemCount: genders.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final isSelected = selectedGender == genders[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = genders[index];
                      });
                    },
                    child: buildChipButton(
                      genders[index],
                      isSelected,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Distance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MinimalHeadingText(leftText: "Distance", rightText: ''),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      allowedInteraction: SliderInteraction.slideThumb,
                      value: selectedDistance,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      thumbColor: primaryColor,
                      activeColor: primaryColor,
                      label: "${selectedDistance.toInt()} km",
                      onChanged: (value) {
                        setState(() {
                          selectedDistance = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    "${selectedDistance.toInt()} km",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MinimalHeadingText(leftText: "Price", rightText: ''),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 35,
              child: ListView.builder(
                itemCount: prices.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final isSelected = selectedPrice == prices[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPrice = prices[index];
                      });
                    },
                    child: buildChipButton(
                      prices[index],
                      isSelected,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Apply button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  text: 'Apply Filters',
                  onpressed: () {
                    Navigator.pop(context, {
                      'services': selectedService,
                      'gender': selectedGender,
                      'distance': selectedDistance,
                      'priceRange': selectedPrice,
                    });
                  },
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Service Circle
  Widget buildCategoryCircle(BuildContext context, Icon icon, String title) {
    final isSelected = selectedService == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = title;
        });
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: isSelected ? primaryColor : Colors.black12,
              ),
              color: isSelected ? primaryColor.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: isSelected ? primaryColor : Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  /// Generic chip for Gender/Price
  Widget buildChipButton(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 3),
      child: Container(
        height: 30,
        width: 90,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          border: Border.all(
            width: 1.5,
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black54,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
