// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_application/screens/admin/admin_login.dart';
import 'package:student_application/screens/admin/admin_screen.dart';
import 'package:student_application/screens/admin/admin_uploadScreen.dart';
import 'package:student_application/screens/news_Article.dart';
import 'package:student_application/screens/onboardingScreen.dart';
import 'package:student_application/screens/upload_screen.dart';
import 'package:student_application/theme.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/study_materials_screen.dart'; // Import your Study Materials screen
import 'screens/see_all.dart'; // Import your Help Request screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    TheResponsiveBuilder(
      builder: (
        context, Orientation, ScreenType ){
      return MyApp();})
   );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/onboarding'
          : FirebaseAuth.instance.currentUser?.email == 'elvisngwu18@gmail.com'
              ? '/admin' // Navigate to Admin screen if the logged-in user is admin
              : '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        "/admin": (context) => AdminHomePage(),
        "/onboarding": (context) => Onboardingscreen(),
        '/home': (context) => HomePage(),
        '/uploadScreen': (context) => UploadResourcePage(),
         '/profile': (context) => ProfileScreen(),
        '/materials': (context) => StudyMaterialScreen(),
        '/viewAll': (context) => ViewAll(),
        '/adminUploadScreen' : (context) =>  AdminUpload(),
      
        // '/AdminLogin' : (context) => AdminLoginScreen(),
        
      },
    );
  }
}
