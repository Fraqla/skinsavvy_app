// views/ingredient_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/ingredient_view_model.dart';

class IngredientView extends StatelessWidget {
  const IngredientView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<IngredientViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Ingredient Analysis')),
      body: FutureBuilder(
        future: viewModel.fetchIngredients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: viewModel.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = viewModel.ingredients[index];
              return ListTile(
                title: Text(ingredient.ingredientName),
                subtitle: Text(ingredient.function),
                leading: ingredient.image.isNotEmpty
                    ? Image.network(ingredient.image, width: 50, height: 50)
                    : null,
                onTap: () {
                  // Navigate to ingredient details or show more info
                },
              );
            },
          );
        },
      ),
    );
  }
}
