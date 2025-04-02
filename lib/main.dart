import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'providers/user_provider.dart';
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
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            title: 'SleepReset',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color(0xFF2A1965),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Color(0xFF2A1965),
                secondary: Color(0xFFD56CFF),
                tertiary: Color(0xFFF3B775),
              ),
              fontFamily: 'DM Sans',
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                  letterSpacing: 0.24,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 0.16,
                ),
                labelLarge: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 0.16,
                ),
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  userProvider.setUser(snapshot.data); // עדכון בסיסי של ה-UserProvider
                  return HomeScreen();
                }
                userProvider.setUser(null);
                return LoginScreen();
              },
            ),
            routes: {
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
          );
        },
      ),
    );
  }
}