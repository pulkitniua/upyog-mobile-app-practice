import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upyog/services/token_service.dart';

import 'package:upyog/widgets/citizen_services.dart';

class OtpEntryScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpEntryScreen({super.key, required this.mobileNumber});

  @override
  _OtpEntryScreenState createState() => _OtpEntryScreenState();
}

class _OtpEntryScreenState extends State<OtpEntryScreen> {
  // Controllers for OTP input

  //final String accessToken ="a691e8ef-750d-4b62-bf38-925b6a5c8580"; // accesstoken
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  // Function to handle OTP verification API call
  Future<void> onVerifyOtpPressed(BuildContext context) async {
    // Extract OTP from the OTP fields
    String otp = '';
    for (var controller in _otpControllers) {
      otp += controller.text;
    }

    // Check if OTP is complete
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit OTP.')),
      );
      return;
    }

    // Prepare the payload for API call
    final payload = {
      "username": widget.mobileNumber, // Mobile number as username
      "password": otp, // OTP as password
      "tenantId": "pg",
      "userType": "citizen",
      "scope": "read",
      "grant_type": "password",
    };

    // API URL
    final url = Uri.parse('https://niuatt.niua.in/user/oauth/token');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo="
        },
        body: payload,
      );
      print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

      if (response.statusCode == 200) {
         final responseData = json.decode(response.body);
      String token = responseData['access_token']; // Get the token from response
     
      await TokenStorage.saveToken(token);  // Save token 
        // On success, you can navigate to the next screen or show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified Successfully!')),
        );
        // Optionally, navigate to next screen after successful login:
         print(token);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CitizenServices()));
      } else {
        // On failure, show error message

        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to verify OTP , error code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Error during OTP verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during OTP verification')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the content to start from top
          children: [
            const SizedBox(
                height: 40), // Added space to push content down a bit
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                height: 10), // Added space between text and input row
            const Text(
              'Enter the 6-digit OTP sent to your mobile number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40), // Adjusted spacing before OTP input
            OtpInputRow(
                controllers: _otpControllers), // Pass the controllers here
            const SizedBox(
                height: 40), // Increased spacing to push the button lower
            ElevatedButton(
              onPressed: () => onVerifyOtpPressed(context), // Trigger API call
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D143F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Verify OTP',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OtpInputRow({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: controllers[index],
            keyboardType: TextInputType.number,
            maxLength: 1, // Only allow 1 digit per box
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              counterText: '', // Remove the length counter
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Move to the next box
                if (index < 5) {
                  FocusScope.of(context).nextFocus();
                } else {
                  // If it's the last box, close the keyboard
                  FocusScope.of(context).unfocus();
                }
              } else if (value.isEmpty && index > 0) {
                // Move to the previous box if backspace is pressed
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
