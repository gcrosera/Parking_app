import 'package:flutter/material.dart';
import 'package:parking_search_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/parking_spot.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParkingSpotsProvider()),
      ],
      child: MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
      ),
      home: Login(),
    );
  }
}

//flutter run -d chrome --web-port=61145
