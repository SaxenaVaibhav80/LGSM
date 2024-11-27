import 'package:flutter/material.dart';
import 'package:lsgm_app/screens/login_screen.dart';
import 'package:lsgm_app/screens/signup_screen.dart';



class AppRoutes {
  // Route names as static constants
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
        initial: (context) =>
            const LoginScreen(), // Setting login as initial screen
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
      };

  // Handle unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(
            'No route defined for ${settings.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  // Navigation methods
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }

  // Go back to previous screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Navigate and remove all previous routes
  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }
}
