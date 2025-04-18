import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/skin_knowledge_view_model.dart';
import '../../../models/skin_knowledge_model.dart';
import 'skin_type_detail_view.dart';

class SkinKnowledgeView extends StatefulWidget {
  const SkinKnowledgeView({super.key});

  @override
  State<SkinKnowledgeView> createState() => _SkinKnowledgeViewState();
}

class _SkinKnowledgeViewState extends State<SkinKnowledgeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SkinKnowledgeViewModel>(context, listen: false)
          .fetchSkinKnowledge();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Skin Type Guide',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: const Color(0xFF4DB6AC), // Soft teal
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<SkinKnowledgeViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
            ));
          } else if (vm.error != null) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(vm.error!,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => vm.fetchSkinKnowledge(),
                  child: const Text('Retry',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Discover Your Skin Type',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333))),
                  const SizedBox(height: 8),
                  const Text(
                      'Learn about different skin types and find the best care routine',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF666666))),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: vm.knowledgeList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = vm.knowledgeList[index];
                        return _SkinTypeCard(skinType: item);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _SkinTypeCard extends StatelessWidget {
  final SkinKnowledgeModel skinType;

  const _SkinTypeCard({required this.skinType});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SkinTypeDetailView(skinInfo: skinType),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(16.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            skinType.image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        ),
        title: Text(
          skinType.skinType,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        subtitle: Text(
          skinType.characteristics.join(', '),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
