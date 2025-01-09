import 'package:flutter/material.dart';

class LocalitiesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> localities;

  const LocalitiesScreen({super.key, required this.localities});

  @override
  _LocalitiesScreenState createState() => _LocalitiesScreenState();
}

class _LocalitiesScreenState extends State<LocalitiesScreen> {
  String? selectedCity;
  String? selectedLocality;

  @override
  void initState() {
    super.initState();
    // Set the default selected locality (City A)
    selectedCity = 'City A';
    if (widget.localities.isNotEmpty) {
      selectedLocality =
          widget.localities[0]['name']; // Set first locality as selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Localities'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the first radio button (for City A)
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
                      selectedLocality = value;
                    });
                  },
                ),
              ),
            ),
            // Display radio buttons for each locality
            for (var locality in widget.localities)
              ListTile(
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
                    onChanged: (value) {
                      setState(() {
                        selectedLocality = value;
                      });
                    },
                  ),
                ),
              ),
            // Optional: Add a Next button for navigation
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D143F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                ),
                onPressed: () {},
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
