// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_view_model.dart';
import 'views/landing_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SkinSavvy',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Arial',
        ),
        home: const LandingView(),
      ),
    );
  }
}
