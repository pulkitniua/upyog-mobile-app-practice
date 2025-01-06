import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upyog/widgets/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false; // State to manage checkbox value
  bool isMobileEntered = false; // State to check if mobile number is entered
  TextEditingController mobileController = TextEditingController();

  Future<void> onContinueButtonPressed() async {
    print("Inside onContinueButtonPressed");

    final mobileNumber = mobileController.text;
    if (mobileNumber.isEmpty) {
      print("Mobile number is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number.")),
      );
      return; // Stop further execution if mobile number is empty
    }

    final url =
        Uri.parse('https://niuatt.niua.in/user-otp/v1/_send?tenantId=pg');
    final payload = {
      "otp": {
        "mobileNumber": mobileNumber,
        "tenantId": "pg",
        "userType": "citizen",
        "type": "login"
      },
      "RequestInfo": {
        "apiId": "Rainmaker",
        "msgId": "1736138581090|en_IN",
        "plainAccessRequest": {}
      }
    };

    try {
      print("Sending API request with payload: $payload");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        print("OTP sent successfully, navigating to OTP screen");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  OtpEntryScreen(mobileNumber: mobileNumber)),
        );
      } else {
        print("Failed to send OTP");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to send OTP. Code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Exception occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while sending OTP.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            children: [
              // Green container starts here
              Container(
                width: screenWidth * 0.9, // Adjust the width of the container
                height: screenHeight * 0.7, // Height of the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Provide your mobile number',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'All the communications regarding the application will be sent to this mobile number.',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Mobile number',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                '+91',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Check if mobile number is entered
                                    isMobileEntered = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // New Row with Checkbox and Privacy Policy Message
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                "I agree to the UPYOG's Privacy Policy",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Continue Button (Full width)
                        Center(
                          child: ElevatedButton(
                            onPressed: (isMobileEntered && isChecked)
                                ? onContinueButtonPressed
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8D143F),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(
                                  double.infinity, 50), // Full width button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
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
    );
  }
}
