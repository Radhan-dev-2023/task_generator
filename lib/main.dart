import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_assigner/Home_Screen.dart';
import 'package:task_assigner/Login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAVxJxmWlDb6bU47GBPcxYzH8fASYt1Kfw",
          appId: "1:518644364990:android:8ad85ba1a77d65b7ef50ef",
          messagingSenderId: "518644364990",
          projectId: "taskassigner-74233"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: /*HomeScreen*/LoginScreen(),
    );
  }
}
