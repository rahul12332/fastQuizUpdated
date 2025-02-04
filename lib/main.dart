import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/core/app_theme.dart';
import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:fast_quiz_tayari/userPart/core/routes.dart';
import 'package:fast_quiz_tayari/userPart/view/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.theme, // Set navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Set icon brightness
      statusBarColor: AppColor.theme, // Set status bar color
      statusBarIconBrightness:
          Brightness.light, // Set status bar icon brightness
    ),
  );
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Quiz Tayari',
      theme: AppTheme.themeData,
      home: SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
