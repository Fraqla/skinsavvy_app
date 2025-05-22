import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/models/review_model.dart';
import 'package:skinsavvy_app/views/login_view.dart';
import '../../viewmodels/review_view_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ReviewView extends StatefulWidget {
  final int productId;
  const ReviewView({super.key, required this.productId});

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedRating = 5;
  File? selectedPhoto;
  XFile? selectedPhotoWeb;
  Uint8List? webImage;
  final picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reviewVM = Provider.of<ReviewViewModel>(context, listen: false);
      reviewVM.checkAuthentication();
      reviewVM.fetchReviews(widget.productId);
    });
  }

  Future<void> pickPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
          selectedPhotoWeb = pickedFile;
        });
      } else {
        setState(() {
          selectedPhoto = File(pickedFile.path);
        });
      }
    }
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildRatingStars(review.rating),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.review,
              style: const TextStyle(fontSize: 14),
            ),
            if (review.photo != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "http://localhost:8000/review-image/${review.photo!.split('/').last}",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${review.rating}/5',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Login to submit a review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              ).then((_) {
                final reviewVM = Provider.of<ReviewViewModel>(context, listen: false);
                reviewVM.checkAuthentication();
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Login Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final reviewVM = Provider.of<ReviewViewModel>(context, listen: false);
    
    try {
      await reviewVM.addReview(
        widget.productId,
        reviewController.text,
        selectedRating.toDouble(),
        kIsWeb ? null : selectedPhoto,
        kIsWeb ? webImage : null,
      );
      
      reviewController.clear();
      setState(() {
        selectedPhoto = null;
        webImage = null;
      });
      
      await reviewVM.fetchReviews(widget.productId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      String errorMessage = 'Failed to submit review';
      if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Session expired. Please login again.';
        reviewVM.checkAuthentication();
        _showLoginPrompt(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewVM = Provider.of<ReviewViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Reviews"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: reviewVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviewVM.reviews.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.reviews, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "No reviews yet",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: reviewVM.reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviewVM.reviews[index];
                          return _buildReviewCard(review);
                        },
                      ),
          ),
          reviewVM.isAuthenticated ? _buildReviewForm(reviewVM) : _buildLoginPrompt(),
        ],
      ),
    );
  }

  Widget _buildReviewForm(ReviewViewModel reviewVM) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write a review';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedRating,
              decoration: InputDecoration(
                labelText: 'Rating',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: [1, 2, 3, 4, 5]
                  .map((rating) => DropdownMenuItem(
                        value: rating,
                        child: Text('$rating ${rating == 1 ? 'Star' : 'Stars'}'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedRating = value);
                }
              },
            ),
            const SizedBox(height: 16),
            if ((selectedPhoto != null) || (webImage != null))
              kIsWeb
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(webImage!, height: 100),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(selectedPhoto!, height: 100),
                    ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: pickPhoto,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Add Photo'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Submit Review"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to login to submit a review.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              ).then((_) {
                final reviewVM = Provider.of<ReviewViewModel>(context, listen: false);
                reviewVM.checkAuthentication();
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}