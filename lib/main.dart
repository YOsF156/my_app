import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
import 'screens/privacy_policy_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/signup_screen.dart';
import 'providers/user_provider.dart'; // Import the UserProvider
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((app) {
    print('Firebase initialized with app name: ${app.name}');
  }).catchError((e) {
    print('Firebase initialization error: $e');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
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
          '/change-password': (context) => ChangePasswordScreen(),
          '/signup': (context) => SignupScreen(),
        },
      ),
    );
  }
}
