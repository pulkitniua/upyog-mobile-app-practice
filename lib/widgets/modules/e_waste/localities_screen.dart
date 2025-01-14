import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upyog/providers/ewaste_provider.dart';
import 'package:upyog/models/ewaste_application.dart';
import 'package:upyog/widgets/modules/e_waste/address_details.dart';

class LocalitiesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> localities;

  const LocalitiesScreen({super.key, required this.localities});

  @override
  _LocalitiesScreenState createState() => _LocalitiesScreenState();
}

class _LocalitiesScreenState extends State<LocalitiesScreen> {
  String? selectedCity;
  String? selectedLocality;
  String? selectedLocalityCode;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    // Initialize with existing data from provider if available
    final provider = context.read<EwasteProvider>();
    final currentLocality = provider.formData.address.locality;

    selectedCity = 'City A'; // Default city

    if (currentLocality.code.isNotEmpty) {
      // If we have existing locality in provider
      final existingLocality = widget.localities.firstWhere(
        (locality) => locality['code'] == currentLocality.code,
        orElse: () => widget.localities.first,
      );
      selectedLocality = existingLocality['name'];
      selectedLocalityCode = existingLocality['code'];
    } else if (widget.localities.isNotEmpty) {
      // Default to first locality if no existing selection
      selectedLocality = widget.localities.first['name'];
      selectedLocalityCode = widget.localities.first['code'];
    }
  }

  void _updateLocalityInProvider() {
    if (selectedLocality == null || selectedLocalityCode == null) return;

    final provider = context.read<EwasteProvider>();
    final currentAddress = provider.formData.address;

    // Create new locality
    final updatedLocality = Locality(
      code: selectedLocalityCode!,
      name: selectedLocality!,
    );

    // Create new address with updated locality
    final updatedAddress = Address(
      tenantId: currentAddress.tenantId,
      doorNo: currentAddress.doorNo,
      latitude: currentAddress.latitude,
      longitude: currentAddress.longitude,
      addressNumber: currentAddress.addressNumber,
      type: currentAddress.type,
      addressLine1: currentAddress.addressLine1,
      addressLine2: currentAddress.addressLine2,
      landmark: currentAddress.landmark,
      city: selectedCity ?? 'City A',
      pincode: currentAddress.pincode,
      detail: currentAddress.detail,
      buildingName: currentAddress.buildingName,
      street: currentAddress.street,
      locality: updatedLocality,
    );

    provider.updateAddress(updatedAddress);
  }

  void _handleLocalitySelection(Map<String, dynamic> locality) {
    setState(() {
      selectedLocality = locality['name'];
      selectedLocalityCode = locality['code'];
    });
  }

  void _handleNextPressed() {
    _updateLocalityInProvider();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localities'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City selection
            ListTile(
              title: const Text(
                'City A',
                style: TextStyle(fontSize: 20),
              ),
              leading: Transform.scale(
                scale: 1.5,
                child: Radio<String>(
                  activeColor: const Color(0xFF8D143F),
                  value: 'City A',
                  groupValue: selectedCity,
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
              ),
            ),

            // Localities list
            Expanded(
              child: ListView.builder(
                itemCount: widget.localities.length,
                itemBuilder: (context, index) {
                  final locality = widget.localities[index];
                  return ListTile(
                    title: Text(
                      locality['name'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    leading: Transform.scale(
                      scale: 1.5,
                      child: Radio<String>(
                        activeColor: const Color(0xFF8D143F),
                        value: locality['name'],
                        groupValue: selectedLocality,
                        onChanged: (_) => _handleLocalitySelection(locality),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D143F),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 10,
                    ),
                  ),
                  onPressed: selectedLocality != null ? _handleNextPressed : null,
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}