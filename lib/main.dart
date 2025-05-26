// ===========================================================
// Project Title : NEMSUNITE
// Description   : Final project for Mobile Computing 2
// Created by    : Third-Year Students, Batch 2024
// Course        : Mobile Computing 2
// Institution   : NEMSU (North Eastern Mindanao State University)
// Date          : 2nd Semester, Academic Year 2024
// ===========================================================

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mike_test_app/mc/controllers/auth_controller.dart';
import 'package:mike_test_app/mc/views/screens/auth_screen/login_page.dart';
// Import your AuthController file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Platform.isAndroid) {
      // Web-specific Firebase initialization with options
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: '',
          appId: '',
          messagingSenderId: '',
          projectId: '',
          storageBucket: '',
          //This project is created by the third year student of Batch 2024 as final project for Mobile computing 2
          // The Firebase account and project credentials used in this application are owned and maintained by Edison Tanza (Please read the README.md file)
        ),
      );
    } else {
      // iOS and other platforms initialization
      await Firebase.initializeApp();
    }

    // Create the default admin account after Firebase is initialized
    AuthController authController = AuthController();
    await authController.createDefaultAdmin();
  } catch (e) {
    print('Firebase initialization or admin creation failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nemsu Unite - BSCS-C',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen());
  }
}
