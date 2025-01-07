import 'package:flutter/material.dart';

class ApplicantDetails extends StatefulWidget {
  const ApplicantDetails({super.key});

  @override
  State<ApplicantDetails> createState() => _ApplicantDetailsState();
}

class _ApplicantDetailsState extends State<ApplicantDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Applicant Details'),centerTitle: true,),
    );
  }
}