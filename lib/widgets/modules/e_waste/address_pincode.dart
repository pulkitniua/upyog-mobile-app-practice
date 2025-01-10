import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upyog/services/token_service.dart';
import 'dart:convert';
import 'package:upyog/widgets/modules/e_waste/localities_screen.dart';

class AddressPincode extends StatefulWidget {
  const AddressPincode({super.key});

  @override
  State<AddressPincode> createState() => _AddressPincodeState();
}

class _AddressPincodeState extends State<AddressPincode> {
  final TextEditingController _pincodeController = TextEditingController();

  // Function to call the API
  Future<List<Map<String, dynamic>>> callApi(String pincode) async {
    const url =
        'https://niuatt.niua.in/egov-location/location/v11/boundarys/_search?hierarchyTypeCode=REVENUE&boundaryType=Locality&tenantId=pg.citya';

     // Fetch the token using TokenStorage
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
      final payload = {
      "RequestInfo": {
        "apiId": "Rainmaker",
        "authToken": token, // Use the fetched token here
        "msgId": "1736396781738|en_IN",
        "plainAccessRequest": {}
      },
    };

    

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        final data = json.decode(response.body);
        print(data);
        final localities = data['TenantBoundary'][0]['boundary']
            .where((boundary) {
              // Ensure boundary['pincode'] is a list and contains the entered pincode
              if (boundary['pincode'] != null && boundary['pincode'] is List) {
                return (boundary['pincode'] as List).contains(int.parse(pincode));
              }
              return false;
            })
            .toList();

        // Return the list of localities
       return localities.map<Map<String, dynamic>>((boundary) {
  return {
    'name': boundary['name'],
    'pincode': boundary['pincode'],
  };
}).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Pincode'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Pincode',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pincodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D143F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                ),
                onPressed: () async {
                  String pincode = _pincodeController.text.trim();
                  if (pincode.isNotEmpty) {
                    // Fetch localities based on pincode
                    List<Map<String, dynamic>> localities = await callApi(pincode);

                    // If data exists, navigate to the next screen
                    if (localities.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalitiesScreen(localities: localities),
                        ),
                      );
                    } else {
                      // Show error if no localities found
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No localities found')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a pincode')),
                    );
                  }
                },
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
