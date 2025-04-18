// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_view_model.dart';
import 'viewmodels/category_view_model.dart';
import 'viewmodels/product_view_model.dart';
import 'viewmodels/tips_view_model.dart';
import 'views/landing_view.dart';
import 'viewmodels/skin_knowledge_view_model.dart';
import 'viewmodels/prohibited_product_view_model.dart';

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
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProducViewModel()),
        ChangeNotifierProvider(create: (_) => TipsViewModel()),
        ChangeNotifierProvider(create: (_) => SkinKnowledgeViewModel()),
        ChangeNotifierProvider(create: (_) => ProhibitedProductViewModel()),
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
