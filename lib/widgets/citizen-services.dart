import 'package:flutter/material.dart';

class CitizenServices extends StatefulWidget {
  const CitizenServices({super.key});

  @override
  State<CitizenServices> createState() => _CitizenServicesState();
}

class _CitizenServicesState extends State<CitizenServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Citizen Services'),
    ));
  }
}
