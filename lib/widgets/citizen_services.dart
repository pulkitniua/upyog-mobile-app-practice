import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:upyog/services/token_service.dart';
import 'package:upyog/widgets/login_screen.dart';
import 'package:upyog/widgets/modules/e_waste/product_details.dart';
import "package:http/http.dart" as http;
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
      drawer: const SideDrawer(), // Add the side drawer here
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductDetails()));
                },
                child: const Text(
                  'Create E-Waste Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8D143F), // Link color
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> logout() async {
      String? accessToken = await TokenStorage.getToken();
 
    print(accessToken);
  //String url = "https://niuatt.niua.in/user/_logout?access_token=$accessToken";

  String url = "https://niuatt.niua.in/user/_logout?tenantId=pg";
 final payload = {
    "access_token": accessToken,
    "RequestInfo": {
        "apiId": "Rainmaker",
        "authToken": accessToken ,
        "msgId": "1736502624052|en_IN",
        "plainAccessRequest": {}
    }
};
  // Set the headers
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Basic ZWdvdi11c2VyLWNsaWVudDplZ292LXVzZXItc2VjcmV0", 
  };

  try {
    // Send the POST request to the logout endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body:jsonEncode(payload),
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
       Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen())); // Example
      print('Logout  successfull');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text('You have been sucessfully logged out')));
      // Navigate to the login screen after logout
    } else {
      print('Logout failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during logout: $e');
  }
}

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Rupesh'),
            accountEmail: Text('atul@niua.org'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 70, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Add logout API integration here
              logout();
             
            },
          ),
        ],
      ),
    );
  }
}
