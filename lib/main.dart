import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_application/screens/admin_screen.dart';
import 'package:student_application/screens/onboardingScreen.dart';
import 'package:student_application/screens/upload_screen.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/study_materials_screen.dart'; // Import your Study Materials screen
import 'screens/help_request_screen.dart'; // Import your Help Request screen
import 'screens/global_chat_screen.dart'; // Import your Chat screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load saved theme preference
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Toggle theme
  void _toggleTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
    });
    prefs.setBool('darkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Hub',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/onboarding'
          : FirebaseAuth.instance.currentUser?.email == 'admin@gmail.com'
              ? '/admin' // Navigate to Admin screen if the logged-in user is admin
              : '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        "/admin": (context) => AdminScreen(),
        "/onboarding": (context) => Onboardingscreen(),
        '/home': (context) => HomeScreen(),
        '/uploadScreen': (context) => UploadResourcePage(),
        '/profile': (context) => ProfileScreen(toggleTheme: _toggleTheme),
        '/materials': (context) => StudyMaterialScreen(),
        '/help': (context) => HelpRequestScreen(),
        '/chat': (context) => GlobalChatScreen(),
      },
    );
  }
}
