import 'package:flutter/material.dart';
import 'package:gyan/HomeScreen.dart';
import 'package:gyan/LoginScreen.dart';
import 'package:gyan/ProfileUpdateScreen.dart';
import 'package:gyan/RegisterScreen.dart';
import 'package:gyan/RegistrationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RegisterScreen.id:(context)=>RegisterScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        HomeScreen.id:(context)=>HomeScreen()
      },
      home: RegistrationScreen(),
    );
  } 
}