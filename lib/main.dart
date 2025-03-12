import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/configuration_screen.dart';
import 'screens/random_quote_screen.dart';
import 'screens/session_instructions_screen.dart';
import 'screens/session_screen.dart';
import 'screens/session_completion_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/privacy_policy_screen.dart'; // Add this import
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SleepReset',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/configuration': (context) => ConfigurationScreen(),
        '/random-quote': (context) => RandomQuoteScreen(),
        '/session-instructions': (context) => SessionInstructionsScreen(),
        '/session': (context) => SessionScreen(),
        '/session-completion': (context) => SessionCompletionScreen(),
        '/reminders': (context) => RemindersScreen(),
        '/settings': (context) => SettingsScreen(),
        '/about-us': (context) => AboutUsScreen(),
        '/privacy-policy': (context) => PrivacyPolicyScreen(), // Add this route
      },
    );
  }
}
