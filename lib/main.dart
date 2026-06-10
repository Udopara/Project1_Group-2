import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/ui/screens/login.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/screens/home_screen.dart';
import 'package:formative_assignment1/ui/screens/explore_screen.dart';
import 'package:formative_assignment1/ui/screens/create_screen.dart';
import 'package:formative_assignment1/ui/screens/chats_screen.dart';
import 'package:formative_assignment1/ui/screens/profile_screen.dart';
import 'package:formative_assignment1/ui/screens/post_details_screen.dart';
import 'package:formative_assignment1/ui/screens/RSVP_screen.dart';
import 'package:formative_assignment1/ui/screens/communities_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formative Assignment 1',
      theme: AppTheme.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Public route — always accessible
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => const Register(),
            settings: settings,
          );
        }

        // Auth guard — redirect to login if not logged in
        if (!Session.isLoggedIn) {
          return MaterialPageRoute(
            builder: (_) => const Register(),
            settings: settings,
          );
        }

        // Protected routes
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen(), settings: settings);
          case '/explore':
            return MaterialPageRoute(builder: (_) => const ExploreScreen(), settings: settings);
          case '/create':
            return MaterialPageRoute(builder: (_) => const CreateScreen(), settings: settings);
          case '/chats':
            return MaterialPageRoute(builder: (_) => const ChatsScreen(), settings: settings);
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen(), settings: settings);
          case '/rsvp':
            return MaterialPageRoute(builder: (_) => const RSVP(), settings: settings);
          case '/communities':
            return MaterialPageRoute(builder: (_) => const CommunitiesScreen(), settings: settings);
          case '/post-details':
            final eventId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => PostDetailsScreen(eventId: eventId),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
