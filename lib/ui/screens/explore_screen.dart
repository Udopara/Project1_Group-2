import 'package:flutter/material.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Explore')),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
