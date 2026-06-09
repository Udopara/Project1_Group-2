import 'package:flutter/material.dart';
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
      routes: {
        '/':    (_) => const Register(),
        '/home': (_) => const HomeScreen(),
        '/explore': (_) => const ExploreScreen(),
        '/create':  (_) => const CreateScreen(),
        '/chats':   (_) => const ChatsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/rsvp':   (_) => const RSVP(),
        '/communities':(_) => const CommunitiesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/post-details') {
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
