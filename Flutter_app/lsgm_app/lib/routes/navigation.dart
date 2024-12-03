// lib/config/routes.dart

import 'package:flutter/material.dart';
import 'package:lsgm_app/screens/customer_login_screen.dart';
import 'package:lsgm_app/screens/customer_signup_screen.dart';
import 'package:lsgm_app/screens/shop_confirmation.dart';
import 'package:lsgm_app/screens/shopkeeper_login_screen.dart';
import 'package:lsgm_app/screens/shopkeeper_signup_screen.dart';
import '../screens/role_selection_screen.dart';


class AppRoutes {
  // Route names as static constants
  static const String initial = '/';
  static const String roleSelection = '/role-selection';

  // Authentication routes
  static const String customerLogin = '/login';
  static const String customerSignup = '/signup';
  static const String shopkeeperSignup = '/shopkeeper/signup';
  static const String shopkeeperLogin = '/shopkeeper/login';
  static const String shopConfirmation = '/shopkeeper/confirmation';

  // Customer routes
  static const String customerHome = '/customer/home';
  static const String customerProfile = '/customer/profile';
  static const String customerCart = '/customer/cart';
  static const String customerOrders = '/customer/orders';

  // Shopkeeper routes
  static const String shopkeeperHome = '/shopkeeper/home';
  static const String shopkeeperProfile = '/shopkeeper/profile';
  static const String shopkeeperInventory = '/shopkeeper/inventory';
  static const String shopkeeperOrders = '/shopkeeper/orders';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const RoleSelectionScreen(),
        roleSelection: (context) => const RoleSelectionScreen(),
        customerLogin: (context) => const LoginScreen(),
        customerSignup: (context) => const SignupScreen(),
        shopkeeperSignup: (context) => const ShopkeeperSignupScreen(),
        shopkeeperLogin: (context) => const ShopkeeperLoginScreen(),
        shopConfirmation: (context) {
          // Get the arguments passed during navigation
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;

          return ShopConfirmationScreen(
            shopId: args['shopId'] ?? '',
            shopName: args['shopName'] ?? '',
            shopAddress: args['shopAddress'] ?? '',
          );
        },
        // Customer routes
        // customerHome: (context) => const CustomerHomeScreen(),
        // customerProfile: (context) => const CustomerProfileScreen(),
        // customerCart: (context) => const CustomerCartScreen(),
        // customerOrders: (context) => const CustomerOrdersScreen(),

        // // Shopkeeper routes
        // shopkeeperHome: (context) => const ShopkeeperHomeScreen(),
        // shopkeeperProfile: (context) => const ShopkeeperProfileScreen(),
        // shopkeeperInventory: (context) => const ShopkeeperInventoryScreen(),
        // shopkeeperOrders: (context) => const ShopkeeperOrdersScreen(),
      };

  // Handle unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
            'Route ${settings.name} not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
  static void navigateToAndReplaceWithArgs(
      BuildContext context, String routeName, Map<String, dynamic> args) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: args,
    );
  }
  // Navigation methods
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateToAndClear(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
