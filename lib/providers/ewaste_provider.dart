import 'package:flutter/foundation.dart';
import 'package:upyog/services/token_service.dart';
import '../models/ewaste_application.dart';

class EwasteProvider with ChangeNotifier {
  EwasteApplication formData = EwasteApplication(
    tenantId: "pg.citya",
    vendorUuid: "345",
    calculatedAmount: 0,
    applicant: Applicant(
      applicantName: "",
      mobileNumber: "",
      emailId: "",
      altMobileNumber: "",
    ),
    ewasteDetails: [],
    address: Address(
      tenantId: "pg.citya",
      doorNo: "",
      latitude: null,
      longitude: null,
      addressNumber: "",
      type: "RESIDENTIAL",
      addressLine1: "",
      addressLine2: "",
      landmark: "",
      city: "",
      pincode: "",
      detail: "",
      buildingName: "",
      street: "",
      locality: Locality(code: "", name: ""),
    ),
    documents: [],
    workflow: Workflow(
      businessService: "ewst",
      action: "CREATE",
      moduleName: "ewaste-services",
    ),
  );

  // Update applicant details
  void updateApplicant(Applicant applicant) {
    formData.applicant = applicant;
    notifyListeners();
  }

  // Update address
  void updateAddress(Address address) {
    formData.address = address;
    notifyListeners();
  }

  // Add Ewaste Details
  void addEwasteDetails(EwasteDetails details) {
    formData.ewasteDetails.add(details);
    notifyListeners();
  }

  // Add Documents
  void addDocument(Document document) {
    formData.documents.add(document);
    notifyListeners();
  }

  // Update calculated amount
  void updateCalculatedAmount(int amount) {
    formData.calculatedAmount = amount;
    notifyListeners();
  }

  // Get the complete payload
  Future <Map<String, dynamic>> getPayload() async{
    final authToken = await TokenStorage.getToken();
    return {
      "EwasteApplication": [formData.toJson()],
      "RequestInfo": {
        "apiId": "Rainmaker",
        "authToken": authToken, // Replace with dynamic auth
        "userInfo": {
          "id": 94,
          "uuid": "7c070fcf-276f-41b2-9dd6-11270cc8b150",
          "userName": "9999999999",
          "name": "Rupesh",
          "mobileNumber": "9999999999",
          "emailId": "atul@niua.org",
          "type": "CITIZEN",
          "roles": [
            {"name": "Citizen", "code": "CITIZEN", "tenantId": "pg"}
          ],
          "active": true,
          "tenantId": "pg",
        },
        "msgId": "1736250677905|en_IN",
        "plainAccessRequest": {}
      }
    };
  }
}
