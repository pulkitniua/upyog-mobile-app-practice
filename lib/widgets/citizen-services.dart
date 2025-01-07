import 'package:flutter/material.dart';

class CitizenServices extends StatefulWidget {
  const CitizenServices({super.key});

  @override
  State<CitizenServices> createState() => _CitizenServicesState();
}

class _CitizenServicesState extends State<CitizenServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Services'),
      ),
      body: CitizenServicesCard(),
    );
  }
}

class CitizenServicesCard extends StatelessWidget {
  CitizenServicesCard({super.key});

  final List<String> moduleNames = [
    "Property Tax",
    "E-Waste",
    "Venue Booking",
    "Asset Management",
    "Street Vending",
    "Pet Registration",
    "Advertisement",
    "Trade License",
    "Fire NOC",
    "Building Plan Approval",
    "Finance and Accounting",
    "Miscellaneous Collection",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of cards in a row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2, // Aspect ratio of the card
        ),
        itemCount: moduleNames.length,
        itemBuilder: (context, index) {
          return CustomCard(
            moduleName: moduleNames[index],
            onTap: () {
              // Navigate to a new screen when the card is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ModuleScreen(moduleName: moduleNames[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String moduleName;
  final VoidCallback onTap;

  const CustomCard({Key? key, required this.moduleName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Triggers the onTap action when the card is clicked
      child: Card(
        color: const Color(0xFF8D143F),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            moduleName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// New screen that opens when a card is clicked
class ModuleScreen extends StatelessWidget {
  final String moduleName;

  const ModuleScreen({Key? key, required this.moduleName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            if (moduleName == 'E-Waste') 
            // Show link only for E-Waste
              GestureDetector(
                onTap: () {
                  print('Link clicked');
                },
                child: const Text(
                  'Create E-Waste Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8D143F), // Link color
                    // decoration: TextDecoration.underline,
                  ),
                ),
              )
  
          ],
        ),
      ),
    );
  }
}
