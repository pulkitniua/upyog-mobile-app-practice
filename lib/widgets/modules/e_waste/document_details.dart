import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:upyog/widgets/modules/e_waste/applicant_details.dart';

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({super.key});

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  String _apiResponse = '';  // To store API response for display

  // Function to pick image and call API
  Future<void> _pickImage() async {
    // Image picker to select image
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(pickedFile);
      });

      // Trigger the API call to upload the image
      await _uploadImage(pickedFile);
    }
  }

  // Function to upload image to API
  Future<void> _uploadImage(XFile imageFile) async {
    try {
      var uri = Uri.parse('https://niuatt.niua.in/filestore/v1/files');
      
      // Determine the file type dynamically
      String fileExtension = imageFile.path.split('.').last.toLowerCase();
      MediaType mediaType;

      if (fileExtension == 'jpeg' || fileExtension == 'jpg') {
        mediaType = MediaType('image', fileExtension);  // For images (jpeg, jpg)
      } else if (fileExtension == 'pdf') {
        mediaType = MediaType('application', 'pdf');  // For PDF files
      } else {
        mediaType = MediaType('application', 'octet-stream');  // Fallback for unknown types
      }

      var request = http.MultipartRequest('POST', uri)
        ..fields['tenantId'] = 'pg'
        ..fields['module'] = 'EWASTE'
        ..files.add(await http.MultipartFile.fromPath(
          'file', 
          imageFile.path, 
          contentType: mediaType,  // Set dynamic content type based on file type
        ));

      var response = await request.send();

      // Collect the response body for display
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 201) {
        setState(() {
          _apiResponse = 'File uploaded successfully';
        });
      } else {
        setState(() {
          _apiResponse = 'Failed! Status Code: ${response.statusCode}\nResponse Body: $responseBody';
        });
      }
    } catch (e) {
      print("Error occurred during image upload: $e");
      setState(() {
        _apiResponse = 'Error occurred during the upload: $e';
      });
    }
  }

  // Function to navigate to the next screen
  void _goToNextScreen() {
    
   Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicantDetails()));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Document:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D143F),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Choose Image',style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            // Display selected images
            if (_imageFiles.isNotEmpty)
              Column(
                children: _imageFiles.map((file) {
                  return ListTile(
                    leading: file.name.endsWith('.pdf')
                        ? const Icon(Icons.picture_as_pdf, color: Colors.red)
                        : Image.file(File(file.path), width: 50, height: 50),
                    title: Text(file.name),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            // Display API response (success/failure)
            if (_apiResponse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _apiResponse,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            
            // Next button to navigate to the next screen
            ElevatedButton(
              onPressed: _goToNextScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D143F),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

