import 'package:flutter/material.dart';

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({super.key});

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Details'),),
    );
  }
}