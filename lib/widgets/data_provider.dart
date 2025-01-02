import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {
  Map<String, dynamic> _mdmsData = {};

  // Getter for raw data
  Map<String, dynamic> get mdmsData => _mdmsData;

  // Fetch API data
  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://niuatt.niua.in/egov-mdms-service/v1/_search?tenantId=pg');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "MdmsCriteria": {
        "tenantId": "pg",
        "moduleDetails": [
          {
            "moduleName": "common-masters",
            "masterDetails": [
              {"name": "StateInfo"}
            ]
          },
          {
            "moduleName": "tenant",
            "masterDetails": [
              {"name": "tenants"}
            ]
          }
        ]
      },
      "RequestInfo": {
        "apiId": "Rainmaker",
        "msgId": "1722101824836|en_IN",
        "plainAccessRequest": {}
      }
    };

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
         // Decode the response body using utf8.decode to handle encoding
        String decodedResponse = utf8.decode(response.bodyBytes); // Decode bodyBytes to handle encoding issues
        _mdmsData = jsonDecode(decodedResponse)['MdmsRes'] ?? {};
        notifyListeners(); // Notify listeners when data changes
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
