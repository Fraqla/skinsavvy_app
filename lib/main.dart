import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/services/api_service.dart';
import 'package:skinsavvy_app/services/auth_provider.dart';
import 'package:skinsavvy_app/viewmodels/compare_product_view_model.dart';
import 'package:skinsavvy_app/views/content/promotion/promotion_detail_view.dart';
import 'package:skinsavvy_app/viewmodels/login_view_model.dart';
import 'package:skinsavvy_app/viewmodels/category_view_model.dart';
import 'package:skinsavvy_app/viewmodels/product_view_model.dart';
import 'package:skinsavvy_app/viewmodels/tips_view_model.dart';
import 'package:skinsavvy_app/views/landing_view.dart';
import 'package:skinsavvy_app/viewmodels/skin_knowledge_view_model.dart';
import 'package:skinsavvy_app/viewmodels/prohibited_product_view_model.dart';
import 'package:skinsavvy_app/viewmodels/ingredient_view_model.dart';
import 'package:skinsavvy_app/viewmodels/promotion_view_model.dart';
import 'package:skinsavvy_app/viewmodels/skin_quiz_view_model.dart';
import 'package:skinsavvy_app/viewmodels/wishlist_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AuthService and load token
  final authService = AuthService();
  await authService.loadAuthToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),  
        ChangeNotifierProvider(create: (_) => TipsViewModel()),
        ChangeNotifierProvider(create: (_) => SkinKnowledgeViewModel()),
        ChangeNotifierProvider(create: (_) => ProhibitedProductViewModel()),
        ChangeNotifierProvider(create: (_) => IngredientViewModel()),
        ChangeNotifierProvider(create: (_) => PromotionViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => CompareProductViewModel()),
        ChangeNotifierProvider(create: (context) => SkinQuizViewModel(context)), 
        
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
      debugShowCheckedModeBanner: false,
      title: 'SkinSavvy',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
      ),
      home: const LandingView(),
    );
  }
}
