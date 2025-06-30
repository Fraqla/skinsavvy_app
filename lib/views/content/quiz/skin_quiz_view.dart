import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/viewmodels/login_view_model.dart';
import 'package:skinsavvy_app/views/login_view.dart';
import '../../../viewmodels/skin_quiz_view_model.dart';
import '../../../viewmodels/user_view_model.dart';

class SkinQuizView extends StatefulWidget {
  const SkinQuizView({super.key});

  @override
  State<SkinQuizView> createState() => _SkinQuizViewState();
}

class _SkinQuizViewState extends State<SkinQuizView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = Provider.of<SkinQuizViewModel>(context, listen: false);
      await viewModel.checkAuthentication();
      
      if (viewModel.isAuthenticated) {
        await viewModel.fetchSkinQuizzes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SkinQuizViewModel>(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (!viewModel.isAuthenticated) {
      return _buildLoginPrompt(context, viewModel, theme, colors);
    }
    if (viewModel.skinTypeResult != null) {
      return _buildResultScreen(context, viewModel, theme, colors);
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Skin Type Quiz'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
      ),
      body: _buildQuizScreen(viewModel, theme, colors),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, SkinQuizViewModel viewModel,
      ThemeData theme, ColorScheme colors) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Skin Type Quiz'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 48, color: colors.primary),
              const SizedBox(height: 24),
              Text(
                'Login Required',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You need to login to take the skin type quiz',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  ).then((_) async {
                    await viewModel.checkAuthentication();
                    if (viewModel.isAuthenticated && mounted) {
                      await viewModel.fetchSkinQuizzes();
                      setState(() {});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Login Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizScreen(
      SkinQuizViewModel viewModel, ThemeData theme, ColorScheme colors) {
    if (viewModel.isLoading && viewModel.skinQuizzes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(viewModel.error!,
                style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: viewModel.fetchSkinQuizzes,
            ),
          ],
        ),
      );
    }

    if (viewModel.currentQuestion == null) {
      return Center(
          child: Text('No questions available',
              style: theme.textTheme.headlineSmall));
    }

    final question = viewModel.currentQuestion!;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (viewModel.currentQuestionIndex + 1) /
                  viewModel.skinQuizzes.length,
              minHeight: 10,
              backgroundColor: colors.surfaceVariant,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
              'Question ${viewModel.currentQuestionIndex + 1} of ${viewModel.skinQuizzes.length}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurface.withOpacity(0.7))),
          const SizedBox(height: 16),
          Text(question.question,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                  fontWeight: FontWeight.bold, color: colors.onSurface)),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: question.answers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final answer = question.answers[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: colors.shadow.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: colors.outline.withOpacity(0.2), width: 1),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                          viewModel.answerQuestion(answer.text, answer.score),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(answer.text,
                                    style: theme.textTheme.bodyLarge)),
                            Text('Score: ${answer.score}',
                                style: theme.textTheme.bodySmall),
                            Icon(Icons.chevron_right,
                                color: colors.onSurface.withOpacity(0.5)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, SkinQuizViewModel viewModel,
      ThemeData theme, ColorScheme colors) {
    final skinType = viewModel.skinTypeResult?.toLowerCase() ?? '';
    final skinTypeData = {
      'oily': {'emoji': '🛢️', 'desc': 'Excess sebum production'},
      'dry': {'emoji': '🏜️', 'desc': 'Lacks moisture, feels tight'},
      'combination': {
        'emoji': '⚖️',
        'desc': 'Oily in some areas, dry in others'
      },
      'normal': {'emoji': '✨', 'desc': 'Well-balanced skin'},
      'sensitive': {'emoji': '🌡️', 'desc': 'Easily irritated skin'},
    };

    final emoji = skinTypeData[skinType]?['emoji'] ?? '🧐';
    final desc =
        skinTypeData[skinType]?['desc'] ?? 'Unique skin characteristics';

    return WillPopScope(
      onWillPop: () async {
        await _completeQuizAndReturn(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: const Text('Your Skin Type'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _completeQuizAndReturn(context),
          child: const Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 20),
                      Text(viewModel.skinTypeResult!,
                          style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimaryContainer)),
                      const SizedBox(height: 12),
                      Text(desc,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.onPrimaryContainer.withOpacity(0.8)),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text('Skin Care Tips',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.resetQuiz();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Retake Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<void> _completeQuizAndReturn(BuildContext context) async {
  final viewModel = Provider.of<SkinQuizViewModel>(context, listen: false);
  final userVM = Provider.of<UserViewModel>(context, listen: false);
  final loginVM = Provider.of<LoginViewModel>(context, listen: false);
  
  await viewModel.submitQuizResults(userVM, loginVM);
  
  if (mounted) {
    Navigator.pop(context, true);
  }
}
}