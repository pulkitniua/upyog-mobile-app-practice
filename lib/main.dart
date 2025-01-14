import 'package:flutter/material.dart';
import 'package:upyog/providers/ewaste_provider.dart';
import 'package:upyog/widgets/splash_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/data_provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_)=> DataProvider()),
      ChangeNotifierProvider(create: (_) => EwasteProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
