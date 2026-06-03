import 'package:flutter/material.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
