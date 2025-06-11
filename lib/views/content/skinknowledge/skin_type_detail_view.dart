import 'package:flutter/material.dart';
import '../../../models/skin_knowledge_model.dart';

class SkinTypeDetailView extends StatelessWidget {
  final SkinKnowledgeModel skinInfo;

  const SkinTypeDetailView({super.key, required this.skinInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          skinInfo.skinType,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Hero(
              tag: 'skin-image-${skinInfo.skinType}',
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  child: Image.network(
                    'http://localhost:8000/knowledge-image/${skinInfo.image!.split('/').last}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: const Color(0xFF5D9CEC),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with decorative underline
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        Text(
                          skinInfo.skinType,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5D9CEC), Color(0xFF4A7FC9)],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Characteristics Section
                  _buildSection(
                    title: 'Characteristics',
                    content: skinInfo.characteristics,
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                  ),

                  const SizedBox(height: 24),

                  // Best Ingredients Section
                  _buildSection(
                    title: 'Recommended Ingredients',
                    content: skinInfo.bestIngredient,
                    icon: Icons.spa_outlined,
                    iconColor: Colors.blue,
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  _buildSection(
                    title: 'Description',
                    content: [skinInfo.description],
                    icon: Icons.description_outlined,
                    iconColor: Colors.purple,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...content.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, right: 8),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}