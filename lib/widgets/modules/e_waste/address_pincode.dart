import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:upyog/models/ewaste_application.dart';
import 'package:upyog/services/token_service.dart';
import 'package:upyog/providers/ewaste_provider.dart';
import 'package:upyog/widgets/modules/e_waste/localities_screen.dart';
import 'dart:convert';

class AddressPincode extends StatefulWidget {
  const AddressPincode({super.key});

  @override
  State<AddressPincode> createState() => _AddressPincodeState();
}

class _AddressPincodeState extends State<AddressPincode> {
  final TextEditingController _pincodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize pincode from provider if exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final address = context.read<EwasteProvider>().formData.address;
      if (address.pincode.isNotEmpty) {
        _pincodeController.text = address.pincode;
      }
    });
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchLocalities(String pincode) async {
    const url = 'https://niuatt.niua.in/egov-location/location/v11/boundarys/_search';
    const queryParams = {
      'hierarchyTypeCode': 'REVENUE',
      'boundaryType': 'Locality',
      'tenantId': 'pg.citya'
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final payload = {
      "RequestInfo": {
        "apiId": "Rainmaker",
        "authToken": token,
        "msgId": "${DateTime.now().millisecondsSinceEpoch}|en_IN",
        "plainAccessRequest": {}
      },
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['TenantBoundary']?.isEmpty ?? true) {
          return [];
        }

        final localities = (data['TenantBoundary'][0]['boundary'] as List)
            .where((boundary) {
              final pincodes = boundary['pincode'];
              if (pincodes is List) {
                return pincodes.contains(int.tryParse(pincode));
              }
              return false;
            })
            .map<Map<String, dynamic>>((boundary) => {
                  'name': boundary['name'],
                  'code': boundary['code'],
                  'pincode': boundary['pincode'],
                })
            .toList();

        return localities;
      } else {
        throw Exception('Failed to load localities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching localities: $e');
    }
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a pincode';
    }
    if (value.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid 6-digit pincode';
    }
    return null;
  }

  Future<void> _handleNext() async {
    final pincode = _pincodeController.text.trim();
    final validationError = _validatePincode(pincode);
    
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final localities = await _fetchLocalities(pincode);
      
      if (!mounted) return;

      if (localities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No localities found for this pincode')),
        );
        return;
      }

      // Update provider with pincode
      final provider = context.read<EwasteProvider>();
      final currentAddress = provider.formData.address;
      
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
        city: currentAddress.city,
        pincode: pincode,
        detail: currentAddress.detail,
        buildingName: currentAddress.buildingName,
        street: currentAddress.street,
        locality: currentAddress.locality,
      );
      
      provider.updateAddress(updatedAddress);

      // Navigate to localities screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocalitiesScreen(localities: localities),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Pincode'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Pincode',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _pincodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: "",
                hintText: "Enter 6-digit pincode",
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D143F),
                  padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 6),
                ),
                onPressed: _isLoading ? null : _handleNext,
                child: _isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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