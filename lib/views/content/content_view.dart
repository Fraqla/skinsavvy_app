import 'package:flutter/material.dart';
import 'package:skinsavvy_app/views/landing_view.dart';
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
      {
        "title": "Skin Knowledge",
        "widget": const SkinKnowledgeView(),
        "icon": Icons.auto_stories,
        "color": Colors.blue.shade100
      },
      {
        "title": "Skin Quiz",
        "widget": const SkinQuizView(),
        "icon": Icons.quiz,
        "color": Colors.green.shade100
      },
      {
        "title": "Ingredient Analysis",
        "widget": const IngredientView(),
        "icon": Icons.science,
        "color": Colors.purple.shade100
      },
      {
        "title": "Tips & Tricks",
        "widget": const TipsView(),
        "icon": Icons.lightbulb,
        "color": Colors.orange.shade100
      },
      {
        "title": "Promotions",
        "widget": const PromotionView(),
        "icon": Icons.local_offer,
        "color": Colors.red.shade100
      },
      {
        "title": "Prohibited Products",
        "widget": const ProhibitedProductView(),
        "icon": Icons.warning,
        "color": Colors.yellow.shade100
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Content Library",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingView()),
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: contentItems.length,
          itemBuilder: (context, index) {
            final item = contentItems[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['widget'] as Widget),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}