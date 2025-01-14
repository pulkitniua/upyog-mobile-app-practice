// summary_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upyog/providers/ewaste_provider.dart';
import 'package:http/http.dart' as http;
import 'package:upyog/widgets/modules/e_waste/success_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EwasteProvider>(
      builder: (context, provider, child) {
        final formData = provider.formData;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Summary"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please review your details before submitting',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Address Details'),
                _buildDetailItem('House Number', formData.address.doorNo),
                _buildDetailItem(
                    'Building Name', formData.address.buildingName),
                _buildDetailItem('Street', formData.address.street),
                _buildDetailItem(
                    'Address Line 1', formData.address.addressLine1),
                _buildDetailItem(
                    'Address Line 2', formData.address.addressLine2),
                _buildDetailItem('Landmark', formData.address.landmark),
                _buildDetailItem('City', formData.address.city),
                _buildDetailItem('Pincode', formData.address.pincode),
                const SizedBox(height: 20),
                if (formData.ewasteDetails.isNotEmpty) ...[
                  _buildSectionTitle('E-Waste Details'),
                  ...formData.ewasteDetails.map((detail) => _buildDetailItem(
                      'Item', '${detail.productName} (${detail.quantity})')),
                ],
                const SizedBox(height: 20),
                if (formData.applicant.applicantName.isNotEmpty) ...[
                  _buildSectionTitle('Applicant Details'),
                  _buildDetailItem('Name', formData.applicant.applicantName),
                  _buildDetailItem('Mobile', formData.applicant.mobileNumber),
                  _buildDetailItem('Email', formData.applicant.emailId),
                  if (formData.applicant.altMobileNumber.isNotEmpty)
                    _buildDetailItem(
                        'Alt. Mobile', formData.applicant.altMobileNumber),
                ],
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final provider =
                          Provider.of<EwasteProvider>(context, listen: false);
                      const url =
                          'https://niuatt.niua.in/ewaste-services/ewaste-request/_create';

                      try {
                        final payload = await provider.getPayload();

                        final response = await http.post(
                          Uri.parse(url),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(payload),
                        );

                        if (response.statusCode == 200) {
                          final responseData = jsonDecode(response.body);
                          final requestId =
                              responseData['EwasteApplication'][0]["requestId"]; // Extract request ID

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SuccessScreen(requestId: requestId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to submit form.')),
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'An error occurred while submitting the form.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D143F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Submit",
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'NA' : value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
