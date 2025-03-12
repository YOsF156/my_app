import 'package:flutter/material.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/configuration_screen.dart';
import 'package:my_app/screens/random_quote_screen.dart';
import 'package:my_app/screens/session_instructions_screen.dart';
import 'package:my_app/screens/session_screen.dart';
import 'package:my_app/screens/session_completion_screen.dart';
import 'package:my_app/screens/reminders_screen.dart';
import 'package:my_app/screens/settings_screen.dart';
import 'package:my_app/screens/about_us_screen.dart';
import 'package:my_app/screens/privacy_policy_screen.dart';
import 'package:my_app/screens/change_password_screen.dart'; // Add this import
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
        '/privacy-policy': (context) => PrivacyPolicyScreen(),
        '/change-password': (context) =>
            ChangePasswordScreen(), // Add this route
      },
    );
  }
}
