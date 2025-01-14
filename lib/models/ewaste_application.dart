class EwasteApplication {
  String tenantId;
  String requestId;
  String transactionId;
  String pickUpDate;
  String vendorUuid;
  String requestStatus;
  int calculatedAmount;
  Applicant applicant;
  List<EwasteDetails> ewasteDetails;
  Address address;
  List<Document> documents;
  Workflow workflow;

  EwasteApplication({
    required this.tenantId,
    this.requestId = "",
    this.transactionId = "",
    this.pickUpDate = "",
    required this.vendorUuid,
    this.requestStatus = "New Request",
    required this.calculatedAmount,
    required this.applicant,
    required this.ewasteDetails,
    required this.address,
    required this.documents,
    required this.workflow,
  });

  Map<String, dynamic> toJson() {
    return {
      "tenantId": tenantId,
      "requestId": requestId,
      "transactionId": transactionId,
      "pickUpDate": pickUpDate,
      "vendorUuid": vendorUuid,
      "requestStatus": requestStatus,
      "calculatedAmount": calculatedAmount,
      "applicant": applicant.toJson(),
      "ewasteDetails": ewasteDetails.map((e) => e.toJson()).toList(),
      "address": address.toJson(),
      "documents": documents.map((e) => e.toJson()).toList(),
      "workflow": workflow.toJson(),
    };
  }
}

class Applicant {
  String applicantName;
  String mobileNumber;
  String emailId;
  String altMobileNumber;

  Applicant({
    required this.applicantName,
    required this.mobileNumber,
    required this.emailId,
    required this.altMobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "applicantName": applicantName,
      "mobileNumber": mobileNumber,
      "emailId": emailId,
      "altMobileNumber": altMobileNumber,
    };
  }
}

class EwasteDetails {
  String productId;
  String productName;
  int quantity;
  int price;

  EwasteDetails({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
    };
  }
}

class Address {
  String tenantId;
  String doorNo;
  String? latitude;
  String? longitude;
  String addressNumber;
  String type;
  String addressLine1;
  String addressLine2;
  String landmark;
  String city;
  String pincode;
  String detail;
  String buildingName;
  String street;
  Locality locality;

  Address({
    required this.tenantId,
    required this.doorNo,
    this.latitude,
    this.longitude,
    required this.addressNumber,
    required this.type,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.detail,
    required this.buildingName,
    required this.street,
    required this.locality,
  });

  Map<String, dynamic> toJson() {
    return {
      "tenantId": tenantId,
      "doorNo": doorNo,
      "latitude": latitude,
      "longitude": longitude,
      "addressNumber": addressNumber,
      "type": type,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "landmark": landmark,
      "city": city,
      "pincode": pincode,
      "detail": detail,
      "buildingName": buildingName,
      "street": street,
      "locality": locality.toJson(),
    };
  }
}

class Locality {
  String code;
  String name;

  Locality({
    required this.code,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "name": name,
    };
  }
}

class Document {
  String filestoreId;
  String documentUuid;
  String documentType;

  Document({
    required this.filestoreId,
    required this.documentUuid,
    required this.documentType,
  });

  Map<String, dynamic> toJson() {
    return {
      "filestoreId": filestoreId,
      "documentuuid": documentUuid,
      "documentType": documentType,
    };
  }
}

class Workflow {
  String businessService;
  String action;
  String moduleName;

  Workflow({
    required this.businessService,
    required this.action,
    required this.moduleName,
  });

  Map<String, dynamic> toJson() {
    return {
      "businessService": businessService,
      "action": action,
      "moduleName": moduleName,
    };
  }
}
