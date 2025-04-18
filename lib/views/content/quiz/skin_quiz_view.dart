// views/skin_quiz_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/skin_quiz_view_model.dart';

class SkinQuizView extends StatelessWidget {
   const SkinQuizView({super.key});
   
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SkinQuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Skin Quiz')),
      body: FutureBuilder(
        future: viewModel.fetchSkinQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: viewModel.skinQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = viewModel.skinQuizzes[index];
              return ListTile(
                title: Text(quiz.question),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: quiz.answers
                      .map((answer) => Text('• $answer'))
                      .toList(),
                ),
                onTap: () {
                  // Navigate to quiz details or show options
                },
              );
            },
          );
        },
      ),
    );
  }
}
