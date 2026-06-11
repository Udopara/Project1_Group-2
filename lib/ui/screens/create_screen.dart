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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _campusController = TextEditingController(text: 'Kigali Campus');

  EventCategory _category = EventCategory.academic;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _campusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: AppColors.scaffoldBg,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add an event', style: AppTextStyles.headingLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Create a campus agenda item for students to discover.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                _LabeledField(
                  label: 'Event title',
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Career Mixer',
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Description',
                  child: TextFormField(
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'What should students know?',
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Location',
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Innovation Hub',
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Campus',
                  child: TextFormField(
                    controller: _campusController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Kigali Campus',
                    ),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LabeledField(
                  label: 'Category',
                  child: DropdownButtonFormField<EventCategory>(
                    value: _category,
                    decoration: const InputDecoration(),
                    items: EventCategory.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(_categoryLabel(category)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add Event'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final currentUser = Session.currentUser;
    DummyDatabase.events.add(
      EventModel(
        id: 'evt_${now.microsecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        organizerId: currentUser?.id ?? 'usr_001',
        clubId: currentUser?.clubIds.isNotEmpty == true
            ? currentUser!.clubIds.first
            : 'clb_001',
        category: _category,
        location: _locationController.text.trim(),
        campus: _campusController.text.trim(),
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 1, hours: 2)),
        bannerUrl: 'https://picsum.photos/seed/${now.microsecondsSinceEpoch}/600/300',
        maxAttendees: 100,
        attendeeIds: const [],
        isPublic: true,
        metadata: {
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
          'tags': [_categoryLabel(_category).toLowerCase()],
          'isFeatured': false,
          'registrationDeadline':
              now.add(const Duration(days: 1)).toIso8601String(),
          'ticketPrice': 0.0,
          'currency': 'RWF',
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added.')),
    );
    Navigator.pushReplacementNamed(context, '/');
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

String _categoryLabel(EventCategory category) => switch (category) {
      EventCategory.academic => 'Academic',
      EventCategory.social => 'Social',
      EventCategory.sports => 'Sports',
      EventCategory.tech => 'Workshop',
      EventCategory.cultural => 'Cultural',
      EventCategory.career => 'Career',
    };
