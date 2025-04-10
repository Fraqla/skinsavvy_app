// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/viewmodels/auth_viewmodel.dart';
import 'package:skinsavvy_app/viewmodels/landing_viewmodel.dart';
import 'package:skinsavvy_app/views/landing_page.dart';
import 'package:skinsavvy_app/views/login_page.dart';
import 'package:skinsavvy_app/views/register_view.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => LandingViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinSavvy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}