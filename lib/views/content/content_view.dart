import 'package:flutter/material.dart';
import '../content/tips/tips_view.dart';
import '../content/promotion/promotion_view.dart';
import '../content/skinknowledge/skin_knowledge_view.dart';
import '../content/quiz/skin_quiz_view.dart';
import '../content/ingredient/ingredient_analysis_view.dart';
import '../content/prohibitedproduct/prohibited_product_view.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final contentItems = [
      {"title": "Skin Knowledge", "widget": const SkinKnowledgeView()},
      {"title": "Skin Quiz", "widget": const SkinQuizView()},
      {"title": "Ingredient Analysis", "widget": const IngredientView()},
      {"title": "Tips", "widget": const TipsView()},
      {"title": "Promotion", "widget": const PromotionView()},
      {"title": "Prohibited Product", "widget": const ProhibitedProductView()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Content")),
      body: ListView.builder(
        itemCount: contentItems.length,
        itemBuilder: (context, index) {
          final item = contentItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(item['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['widget'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
