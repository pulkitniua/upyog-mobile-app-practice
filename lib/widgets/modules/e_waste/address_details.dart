import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upyog/models/ewaste_application.dart';
import 'package:upyog/providers/ewaste_provider.dart';
import 'package:upyog/widgets/modules/e_waste/summary_screen.dart';


class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EwasteProvider>(context, listen: false);
      final address = provider.formData.address;
      
      houseNumberController.text = address.doorNo;
      addressLine1Controller.text = address.addressLine1;
      addressLine2Controller.text = address.addressLine2;
      landmarkController.text = address.landmark;
      streetController.text = address.street;
      houseNameController.text = address.buildingName;
    });
  }

  void _saveAddress() {
    final provider = Provider.of<EwasteProvider>(context, listen: false);
    
    final newAddress = Address(
      tenantId: "pg.citya",
      doorNo: houseNumberController.text,
      addressNumber: "",  // You might want to add this field to the form if needed
      type: "RESIDENTIAL",
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      landmark: landmarkController.text,
      city: provider.formData.address.city,  // Maintain existing city
      pincode: provider.formData.address.pincode,  // Maintain existing pincode
      detail: "",
      buildingName: houseNameController.text,
      street: streetController.text,
      locality: provider.formData.address.locality,  // Maintain existing locality
    );

    provider.updateAddress(newAddress);
  }

  bool get isFormValid => 
    houseNumberController.text.isNotEmpty && 
    addressLine1Controller.text.isNotEmpty;

  @override
  void dispose() {
    houseNumberController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    streetController.dispose();
    houseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Details"),
      ),
      body: Consumer<EwasteProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Address Details',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildLabelAndTextField(
                    "Street Name",
                    controller: streetController,
                    onChanged: (value) => setState(() {}),
                  ),
                  buildLabelAndTextField(
                    "House Number *",
                    controller: houseNumberController,
                    onChanged: (value) => setState(() {}),
                  ),
                  buildLabelAndTextField(
                    "House Name",
                    controller: houseNameController,
                    onChanged: (value) => setState(() {}),
                  ),
                  buildLabelAndTextField(
                    "Address Line 1 *",
                    controller: addressLine1Controller,
                    onChanged: (value) => setState(() {}),
                  ),
                  buildLabelAndTextField(
                    "Address Line 2",
                    controller: addressLine2Controller,
                    onChanged: (value) => setState(() {}),
                  ),
                  buildLabelAndTextField(
                    "Landmark",
                    controller: landmarkController,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: isFormValid
                          ? () {
                              _saveAddress();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SummaryScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid
                            ? const Color(0xFF8D143F)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 120,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
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

  Widget buildLabelAndTextField(
    String label, {
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: label.contains('*')
                  ? const Icon(Icons.star, color: Colors.red, size: 10)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}