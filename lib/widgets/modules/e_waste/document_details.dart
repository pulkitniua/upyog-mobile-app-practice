
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:upyog/models/ewaste_application.dart';
import 'package:upyog/providers/ewaste_provider.dart';

import 'package:upyog/widgets/modules/e_waste/applicant_details.dart';

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({super.key});

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  final ImagePicker _picker = ImagePicker();
  String _uploadStatus = '';
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        await _uploadImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error picking image: $e';
      });
      print("Error picking image: $e");
    }
  }

  Future<void> _pickDocument() async {
    try {
      final XFile? pickedFile = await _picker.pickMedia();
      
      if (pickedFile != null) {
        if (pickedFile.name.toLowerCase().endsWith('.pdf')) {
          await _uploadImage(pickedFile);
        } else {
          setState(() {
            _uploadStatus = 'Please select a PDF file';
          });
        }
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error picking document: $e';
      });
      print("Error picking document: $e");
    }
  }

  Future<void> _uploadImage(XFile file) async {
    try {
      setState(() {
        _isUploading = true;
        _uploadStatus = 'Uploading...';
      });

      var uri = Uri.parse('https://niuatt.niua.in/filestore/v1/files');
      
      String fileExtension = file.path.split('.').last.toLowerCase();
      MediaType mediaType;

      if (fileExtension == 'jpeg' || fileExtension == 'jpg') {
        mediaType = MediaType('image', fileExtension);
      } else if (fileExtension == 'pdf') {
        mediaType = MediaType('application', 'pdf');
      } else {
        mediaType = MediaType('application', 'octet-stream');
      }

      var request = http.MultipartRequest('POST', uri)
        ..fields['tenantId'] = 'pg'
        ..fields['module'] = 'EWASTE'
        ..files.add(await http.MultipartFile.fromPath(
          'file', 
          file.path, 
          contentType: mediaType,
        ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          if (responseData['files'] != null && responseData['files'] is List && responseData['files'].isNotEmpty) {
            final String fileStoreId = responseData['files'][0]['fileStoreId'];
            
            if (fileStoreId.isNotEmpty) {
              // Get the count of existing documents to generate the next photo number
            int documentCount = Provider.of<EwasteProvider>(context, listen: false).formData.documents.length + 1;
            print(documentCount);
              final document = Document(
                filestoreId: fileStoreId,
               // documentUuid: DateTime.now().millisecondsSinceEpoch.toString(),
               documentUuid: fileStoreId,
               // documentType: mediaType.mimeType,
              // documentType: "Photo1"
              documentType: "Photo${documentCount + 1}",  // Assign the correct photo number
              );
              //print(mediaType.mimeType);
              Provider.of<EwasteProvider>(context, listen: false).addDocument(document);

              setState(() {
                _uploadStatus = 'File uploaded successfully';
              });
            } else {
              throw Exception('FileStoreId is empty');
            }
          } else {
            throw Exception('Invalid response format');
          }
        } catch (e) {
          setState(() {
            _uploadStatus = 'Error processing response: $e';
          });
          print("Error processing response: $e");
        }
      } else {
        setState(() {
          _uploadStatus = 'Upload failed: ${response.statusCode}\nResponse: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error during upload: $e';
      });
      print("Error during upload: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeDocument(int index) {
    try {
      final provider = Provider.of<EwasteProvider>(context, listen: false);
      provider.formData.documents.removeAt(index);
      provider.notifyListeners();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document removed successfully')),
      );
    } catch (e) {
      print("Error removing document: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing document')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
        //backgroundColor: const Color(0xFF8D143F),
      ),
      body: Consumer<EwasteProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Supporting Documents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8D143F),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Upload Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _pickImage,
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: Text(
                          _isUploading ? 'Uploading...' : 'Upload Image',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D143F),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _pickDocument,
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: Text(
                          _isUploading ? 'Uploading...' : 'Upload PDF',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D143F),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Upload Status
                if (_uploadStatus.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _uploadStatus,
                      style: TextStyle(
                        color: _uploadStatus.contains('successfully') 
                          ? Colors.green 
                          : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Documents List
                if (provider.formData.documents.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Uploaded Documents:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.formData.documents.length,
                      itemBuilder: (context, index) {
                        final document = provider.formData.documents[index];
                        final bool isPdf = document.documentType.contains('pdf');
                        
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8D143F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isPdf ? Icons.picture_as_pdf : Icons.image,
                                color: const Color(0xFF8D143F),
                              ),
                            ),
                            title: Text(
                              'Document ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Type: ${isPdf ? 'PDF Document' : 'Image'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _removeDocument(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.formData.documents.isNotEmpty && !_isUploading
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  ApplicantDetails()),
                            )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D143F),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}