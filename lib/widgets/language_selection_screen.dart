import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upyog/widgets/choose_location.dart';
import 'package:upyog/widgets/data_provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  _ChooseLanguageScreenState createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String? selectedLanguage;
  String? logoUrl;

  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    Provider.of<DataProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context).mdmsData;

    // If data is not yet fetched, show loading indicator
    if (data.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check if languages data is available
    List<Map<String, String>> languages = [];
    if (data['common-masters'] != null &&
        data['common-masters']['StateInfo'] != null) {
      for (var stateInfo in data['common-masters']['StateInfo']) {
        for (var lang in stateInfo['languages']) {
          String label =
              utf8.decode(utf8.encode(lang['label'])); // Decode label if needed
          String value =
              utf8.decode(utf8.encode(lang['value'])); // Decode value if needed
          languages.add({'label': label, 'value': value});
        }
        logoUrl = stateInfo['logoUrl'];
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        centerTitle: true, // Center the logo in the appBar
      ),
      body: Center(
        // Use Center widget here to center the container
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Adjusted alignment to move up
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image placed before the "Choose Language" heading
              if (logoUrl != null)
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Reduced space between image and heading
                  child: Image.network(
                    logoUrl!,
                    height: 70, // Increased logo size
                    width: 150, // Increased logo width
                    fit: BoxFit.contain,
                  ),
                ),
              // Heading outside the white container
              const Padding(
                padding: EdgeInsets.only(
                    bottom: 10.0,
                    top: 20.0), // Reduced padding between heading and image
                child: Text(
                  'Choose Language',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // White container for languages and continue button
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                margin: const EdgeInsets.symmetric(
                    vertical: 20.0), // Add margin around the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                constraints: BoxConstraints(
                  maxHeight: 400, // Constrain the height of the container
                  minHeight: 300, // Set a minimum height
                ),
                child: SingleChildScrollView(
                  // Ensure scrolling if content exceeds height
                  child: Column(
                    children: [
                      // Display radio buttons for each language with spacing
                      for (var lang in languages)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0), // Add more space between items
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Display language label first
                              Expanded(
                                child: Text(
                                  lang['label']!,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              // Then display radio button
                              Transform.scale(
                                scale: 1.5,
                                child: Radio<String>(
                                  value: lang['value']!,
                                  groupValue: selectedLanguage,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedLanguage = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Add Continue button inside the same white container with increased width
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D143F),
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.zero, // Rectangular shape
                          ),
                          minimumSize: const Size(
                              double.infinity, 50), // Increased width
                        ),
                        onPressed: () {
                          // If no language is selected, show a message
                          if (selectedLanguage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 100.0), // Adjust bottom spacing
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Round the corners
                                  ),
                                  content: const Text(
                                      'Please select a language to proceed')),
                            );
                            return;
                          }
                          // Navigate to next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChooseLocation()),
                          );
                        },
                        child: const Text('Continue',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],
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
