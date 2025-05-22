import 'package:flutter/material.dart';
import '../../../models/skin_knowledge_model.dart';

class SkinTypeDetailView extends StatelessWidget {
  final SkinKnowledgeModel skinInfo;

  const SkinTypeDetailView({super.key, required this.skinInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(skinInfo.skinType),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'http://localhost:8000/knowledge-image/${skinInfo.image!.split('/').last}',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Characteristics:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(skinInfo.characteristics.join(', ')),
            const SizedBox(height: 16),
            Text(
              'Best Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(skinInfo.bestIngredient.join(', ')),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(skinInfo.description),
          ],
        ),
      ),
    );
  }
}
