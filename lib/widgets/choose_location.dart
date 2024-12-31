import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  
  final dynamic tenantData;
  const ChooseLocation({super.key,required this.tenantData});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
    List<String> cityNames = [];
     List<String> filteredCityNames = []; // List for filtered cities
     String? _selectedCity; // Track the selected city
     TextEditingController _searchController = TextEditingController(); // Controller for search field
  @override
   @override
  void initState() {
    super.initState();
    _extractCityNames();
     _searchController.addListener(_filterCities); // Listen for changes in the search field
  }
  void _extractCityNames() {
    // Check if the 'tenant' and 'tenants' keys exist
    if (widget.tenantData != null ) {
      final tenants = widget.tenantData as List<dynamic>;
      setState(() {
        cityNames = tenants
            .map((tenant) {
              // Accessing the city and extracting the 'name' field
              final city = tenant['city'];
              return city != null ? city['name'] as String : 'Unknown City';
            })
            .toList();
        filteredCityNames = List.from(cityNames); // Initially show all cities
      });
    } else {
      setState(() {
        cityNames = []; // If there's no tenant data, leave the list empty
        filteredCityNames = [];
      });
    }
  }
   void _filterCities() {
    // Filter cities based on the search query
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredCityNames = cityNames
          .where((city) => city.toLowerCase().contains(query)) // Case-insensitive search
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Received Data:${widget.tenantData}');
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Pop the current screen (navigate back)
          },
       )),
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                    )
                  ],
                ),
              ),
              //second row
              // Second Row: Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Row(
                  children: [
                    Expanded(
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
                  ],
                ),
              ),
              //third row
               Expanded(
                child: ListView.builder(
                  itemCount: filteredCityNames.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  filteredCityNames[index], // City name first
                                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                                const Spacer(), // Spacer to push radio button to the right
                                Transform.scale(
                                  scale: 1.8, // Increase size of the radio button (1.5 times)
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
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            
          ),
        ),
      ),
    );
  }
}
