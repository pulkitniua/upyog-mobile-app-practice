import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upyog/widgets/data_provider.dart';
import 'package:upyog/widgets/login_screen.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<String> cityNames = [];
  List<String> filteredCityNames = [];
  String? _selectedCity;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.fetchData().then((_) {
      _extractCityNames(dataProvider.mdmsData);
    });

    _searchController.addListener(_filterCities);
  }

  void _extractCityNames(Map<String, dynamic> mdmsData) {
    if (mdmsData['tenant'] != null && mdmsData['tenant']['tenants'] != null) {
      final tenants = mdmsData['tenant']['tenants'] as List<dynamic>;
      setState(() {
        cityNames = tenants
            .map((tenant) {
              final city = tenant['city'];
              return city?['name'] ?? 'Unknown City';
            })
            .whereType<String>() // Ensure we only have Strings
            .toList();
        filteredCityNames = List.from(cityNames);
      });
    }
  }

  void _filterCities() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredCityNames = cityNames
          .where((city) => city.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: dataProvider.mdmsData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Choose your location',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    // City List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCityNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  filteredCityNames[index],
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                ),
                                const Spacer(),
                                Transform.scale(
                                  scale: 1.8,
                                  child: Radio<String>(
                                    value: filteredCityNames[index],
                                    groupValue: _selectedCity,
                                    activeColor: const Color(0xFF8D143F),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedCity = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Continue Button
                    SizedBox(width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D143F),
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          if (_selectedCity != null) {
                            print('Selected City: $_selectedCity');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen()));
                          } else {
                            print('No city selected');
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
                                      'Please select a location to proceed')),
                            );
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
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
