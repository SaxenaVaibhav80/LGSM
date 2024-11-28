// lib/screens/auth/shopkeeper_login_screen.dart

import 'package:flutter/material.dart';
import 'package:lsgm_app/routes/navigation.dart';
import 'package:lsgm_app/routes/route_guard.dart';


class ShopkeeperLoginScreen extends StatefulWidget {
  const ShopkeeperLoginScreen({super.key});

  @override
  State<ShopkeeperLoginScreen> createState() => _ShopkeeperLoginScreenState();
}

class _ShopkeeperLoginScreenState extends State<ShopkeeperLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _shopIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically handle the login logic
      // For now, we'll just simulate a successful login
      RouteGuard.handleSuccessfulAuth(context, 'shopkeeper');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Orange decoration at top
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Store Icon
                Center(
                  child: Icon(
                    Icons.store_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // Login Text
                Text(
                  'Shopkeeper Login',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back! Please login to your shop account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),

                // Shop ID field
                TextFormField(
                  controller: _shopIdController,
                  decoration: const InputDecoration(
                    labelText: 'Shop ID',
                    prefixIcon: Icon(Icons.store_outlined),
                    hintText: 'Enter your shop ID',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shop ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('LOGIN'),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a shop account? ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shopkeeperSignup,
                      ),
                      child: const Text('Register Now'),
                    ),
                  ],
                ),

                // Back to Role Selection
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.roleSelection,
                    ),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Change Role'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
