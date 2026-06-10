import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Event';
  final List<String> _categories = [
    'Event',
    'Housing',
    'Peer Support',
    'Opportunity',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill out all required fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authorId = Session.currentUser?.id ?? 'usr_001';
    final now = DateTime.now();
    final post = PostModel(
      id: 'pst_${now.millisecondsSinceEpoch}',
      authorId: authorId,
      content:
          '${_titleController.text.trim()}\n\n${_descriptionController.text.trim()}',
      type: _selectedCategory == 'Event'
          ? PostType.announcement
          : PostType.text,
      imageUrls: [],
      likeIds: [],
      comments: [],
      isPinned: false,
      createdAt: now,
      updatedAt: now,
      metadata: {
        'views': 0,
        'shares': 0,
        'isReported': false,
        'tags': [_selectedCategory.toLowerCase()],
      },
    );

    DummyDatabase.posts.add(post);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your post has been successfully shared!'),
        backgroundColor: AppColors.success,
      ),
    );

    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text('Create Post', style: AppTextStyles.headingLarge),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Container
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Add a cover image', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Input: TITLE
            Text('Post Title', style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _titleController,
              style: TextStyle(color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: "e.g., Leadership Workshop, Roommate Wanted...",
                hintStyle: TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Input: CATEGORY
            Text('Category', style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: AppColors.white,
              style: TextStyle(color: AppColors.textDark, fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _categories.map((String cat) {
                return DropdownMenuItem<String>(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Input: DESCRIPTION
            Text('Description', style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: "Tell the campus more about this...",
                hintStyle: TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Publish Post',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}
