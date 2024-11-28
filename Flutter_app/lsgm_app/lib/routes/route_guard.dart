// lib/utils/route_guard.dart

import 'package:flutter/material.dart';
import 'package:lsgm_app/routes/navigation.dart';
import 'package:lsgm_app/screens/customer_login_screen.dart';
import 'package:lsgm_app/screens/role_selection_screen.dart';

class RouteGuard {
  static bool isAuthenticated = false;
  static String? userRole;

  // Public routes that don't require authentication
  static final List<String> _publicRoutes = [
    AppRoutes.initial,
    AppRoutes.roleSelection,
    AppRoutes.customerLogin,
    AppRoutes.customerSignup,
    AppRoutes.customerSignup,
    AppRoutes.shopkeeperSignup,
  ];

  // Customer-specific routes
  static final List<String> _customerRoutes = [
    AppRoutes.customerHome,
    AppRoutes.customerProfile,
    AppRoutes.customerCart,
    AppRoutes.customerOrders,
  ];

  // Shopkeeper-specific routes
  static final List<String> _shopkeeperRoutes = [
    AppRoutes.shopkeeperHome,
    AppRoutes.shopkeeperProfile,
    AppRoutes.shopkeeperInventory,
    AppRoutes.shopkeeperOrders,
  ];

  // Check if the route is accessible
  static bool canAccessRoute(String routeName) {
    // Allow access to public routes regardless of authentication
    if (_publicRoutes.contains(routeName)) {
      return true;
    }

    // If not authenticated, deny access to protected routes
    if (!isAuthenticated) {
      return false;
    }

    // Handle role-based access
    switch (userRole) {
      case 'customer':
        return _customerRoutes.contains(routeName);
      case 'shopkeeper':
        return _shopkeeperRoutes.contains(routeName);
      default:
        return false;
    }
  }

  // Guard route and handle redirects
  static Route<dynamic>? guardRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';

    // Allow access if the route is accessible
    if (canAccessRoute(routeName)) {
      return null; // Continue with normal routing
    }

    // Handle unauthorized access
    if (!isAuthenticated) {
      // Save attempted route for redirect after login
      _saveAttemptedRoute(routeName);

      // Redirect to login
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    }

    // // Handle role mismatch
    // if (userRole == 'customer') {
    //   return MaterialPageRoute(
    //     builder: (context) => const CustomerHomeScreen(),
    //   );
    // }

    // if (userRole == 'shopkeeper') {
    //   return MaterialPageRoute(
    //     builder: (context) => const ShopkeeperHomeScreen(),
    //   );
    // }

    // Fallback to role selection if role is unknown
    return MaterialPageRoute(
      builder: (context) => const RoleSelectionScreen(),
    );
  }

  // Helper method to save attempted route for post-login redirect
  static String? _attemptedRoute;

  static void _saveAttemptedRoute(String route) {
    if (!_publicRoutes.contains(route)) {
      _attemptedRoute = route;
    }
  }

  // Method to get and clear saved route
  static String? getAndClearAttemptedRoute() {
    final route = _attemptedRoute;
    _attemptedRoute = null;
    return route;
  }

  // Method to handle successful authentication
  static void handleSuccessfulAuth(BuildContext context, String role) {
    isAuthenticated = true;
    userRole = role;

    // Check for saved route
    final savedRoute = getAndClearAttemptedRoute();
    if (savedRoute != null && canAccessRoute(savedRoute)) {
      Navigator.pushReplacementNamed(context, savedRoute);
      return;
    }

    // Default routes based on role
    switch (role) {
      case 'customer':
        Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
        break;
      case 'shopkeeper':
        Navigator.pushReplacementNamed(context, AppRoutes.shopkeeperHome);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  // Method to handle logout
  static void handleLogout(BuildContext context) {
    isAuthenticated = false;
    userRole = null;
    Navigator.pushReplacementNamed(context, AppRoutes.customerLogin);
  }

  // Utility method to check if route requires authentication
  static bool requiresAuth(String routeName) {
    return !_publicRoutes.contains(routeName);
  }

  // Utility method to check if route is role-specific
  static bool isRoleSpecific(String routeName) {
    return _customerRoutes.contains(routeName) ||
        _shopkeeperRoutes.contains(routeName);
  }
}
