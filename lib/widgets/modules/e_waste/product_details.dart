import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upyog/widgets/modules/e_waste/document_details.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<String> productNames = [];
  bool isLoading = true;
  String? selectedProduct;
  String errorMessage = '';
  TextEditingController quantityController = TextEditingController(text: '0');
  TextEditingController unitPriceController = TextEditingController();
  List<Map<String, dynamic>> productsTable = []; // List to store table data

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://niuatt.niua.in/egov-mdms-service/v1/_search?tenantId=pg');
    final payload = {
      "MdmsCriteria": {
        "tenantId": "pg",
        "moduleDetails": [
          {
            "moduleName": "Ewaste",
            "masterDetails": [
              {"name": "ProductName"}
            ]
          }
        ]
      },
      "RequestInfo": {
        "apiId": "Rainmaker",
        "msgId": "1736233032131|en_IN",
        "plainAccessRequest": {}
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final productData = responseData['MdmsRes']['Ewaste']['ProductName'] as List<dynamic>;

        setState(() {
          productNames = productData.map((item) => item['name'] as String).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  void addProductToTable() {
    if (selectedProduct == null || quantityController.text.isEmpty || unitPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields before adding a product')),
      );
      return;
    }

    final quantity = int.tryParse(quantityController.text) ?? 0;
    final unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;

    if (quantity <= 0 || unitPrice <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity and Unit Price must be greater than 0')),
      );
      return;
    }

    final totalPrice = quantity * unitPrice;

    setState(() {
      productsTable.add({
        'productName': selectedProduct,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
      });
      quantityController.text = '0';
      unitPriceController.text = '0';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedProduct added successfully!')),
    );
  }

  void removeProductFromTable(int index) {
    setState(() {
      productsTable.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product removed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Heading
                        const Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Dropdown for selecting product
                        const Text(
                          'Select Product:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            underline: const SizedBox.shrink(),
                            isExpanded: true,
                            hint: const Text(
                              'Choose Product',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            value: selectedProduct,
                            items: productNames.map((product) {
                              return DropdownMenuItem<String>(
                                value: product,
                                child: Text(
                                  product,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedProduct) {
                              setState(() {
                                this.selectedProduct = selectedProduct;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                            iconSize: 30,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Quantity and Unit Price
                        buildInputField('Quantity:', quantityController),
                        const SizedBox(height: 20),
                        buildInputField('Unit Price:', unitPriceController),
                        const SizedBox(height: 20),

                        // Add Product Button
                        ElevatedButton(
                          onPressed: addProductToTable,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D143F),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          ),
                          child: const Text(
                            'Add Product',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Table to display added products
                        const Text(
                          'Added Products:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        productsTable.isEmpty
                            ? const Text('No products added yet.')
                            : Table(
                                border: TableBorder.all(color: Colors.grey),
                                children: [
                                  // Table Header
                                  const TableRow(
                                    decoration: BoxDecoration(color: Colors.grey),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Unit Price', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...productsTable.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final product = entry.value;

                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(product['productName']),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(product['quantity'].toString()),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(product['unitPrice'].toStringAsFixed(2)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(product['totalPrice'].toStringAsFixed(2)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => removeProductFromTable(index),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                        const SizedBox(height: 20),

                        // Next Button
                        if (productsTable.isNotEmpty)
                          Align(
                             alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>const DocumentDetails()));
                               
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8D143F),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController
      controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ],
    );
  }
}
