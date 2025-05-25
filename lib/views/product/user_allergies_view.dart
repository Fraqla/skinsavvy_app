import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skinsavvy_app/models/user_allergy_model.dart';
import 'package:skinsavvy_app/viewmodels/user_allergies_viewmodel.dart';

class UserAllergiesView extends StatefulWidget {
  const UserAllergiesView({super.key});

  @override
  State<UserAllergiesView> createState() => _UserAllergiesViewState();
}

class _UserAllergiesViewState extends State<UserAllergiesView> {
  final TextEditingController _ingredientController = TextEditingController();
  late UserAllergiesViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<UserAllergiesViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAllergies());
  }

  Future<void> _loadAllergies() async {
    try {
      await _viewModel.fetchAllergies();
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to load allergies: ${e.toString()}');
      }
    }
  }

  Future<void> _addAllergy() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    try {
      await _viewModel.addAllergy(_ingredientController.text.trim());
      _ingredientController.clear();
      if (mounted) {
        _showSuccessSnackbar('Allergy added successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to add allergy: ${e.toString()}');
      }
    }
  }

  Future<bool?> _removeAllergy(UserAllergy allergy) async {
    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Removal'),
          content: Text('Remove ${allergy.ingredientName} from your allergies?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ?? false;

      if (confirmDelete) {
        try {
          await _viewModel.removeAllergy(allergy.ingredientName);
          if (mounted) {
            _showSuccessSnackbar('Removed ${allergy.ingredientName}');
          }
        } catch (e) {
          if (mounted) {
            _showErrorSnackbar('Failed to remove: ${e.toString()}');
          }
        }
      }
      return confirmDelete;
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error during removal: ${e.toString()}');
      }
      return false;
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Allergies', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAddAllergyField(),
            const SizedBox(height: 24),
            _buildAllergiesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAllergyField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.pink[300]),
                const SizedBox(width: 8),
                Text(
                  'Add New Allergy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Enter ingredient name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                        suffixIcon: _ingredientController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () => _ingredientController.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an ingredient';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _addAllergy(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer<UserAllergiesViewModel>(
                    builder: (context, viewModel, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: viewModel.isLoading ? Colors.grey[300] : Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: viewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check, color: Colors.white),
                          onPressed: viewModel.isLoading ? null : _addAllergy,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesList() {
    return Expanded(
      child: Consumer<UserAllergiesViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.allergies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            );
          }

          if (viewModel.error != null && viewModel.allergies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    ),
                    onPressed: _loadAllergies,
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (viewModel.allergies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_mosaic,
                    size: 72,
                    color: Colors.pink[100],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No allergies added yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add ingredients you want to avoid',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.pink,
            onRefresh: _loadAllergies,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: viewModel.allergies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final allergy = viewModel.allergies[index];
                return Dismissible(
                  key: Key(allergy.id.toString()),
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.red[400]),
                  ),
                  confirmDismiss: (direction) => _removeAllergy(allergy),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber,
                          color: Colors.pink[300],
                        ),
                      ),
                      title: Text(
                        allergy.ingredientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Added ${DateFormat('MMM d, y').format(allergy.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.grey[400],
                        ),
                        onPressed: () => _removeAllergy(allergy),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}