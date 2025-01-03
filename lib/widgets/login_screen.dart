import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false; // State to manage checkbox value

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                width: screenWidth * 0.9,  // Adjust the width of the container
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
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                            const Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                ),
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
                            onPressed: () {
                              // button logic here
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8D143F), 
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50), // Full width button
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
