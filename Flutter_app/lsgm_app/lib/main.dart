import 'package:flutter/material.dart';
import 'package:lsgm_app/screens/role_selection_screen.dart';
import 'package:lsgm_app/screens/shopkeeper_homeScreen.dart';
import 'package:lsgm_app/screens/user_homeScreen.dart';
import 'package:lsgm_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // initialRoute: AppRoutes.initial,
      home: RoleSelectionScreen(),
    );
  }
}
