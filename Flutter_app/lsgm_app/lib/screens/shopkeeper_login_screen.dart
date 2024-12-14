// lib/screens/auth/shopkeeper_login_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lsgm_app/routes/navigation.dart';
import 'package:lsgm_app/screens/shopkeeper_homeScreen.dart';
import 'package:lsgm_app/screens/shopkeeper_signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _shopIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:9000/api/shopkeeper/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'shopid': _shopIdController.text, // matches server's expected field
            'password': _passwordController.text,
          }),
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['success']) {
          // Store the token
          final token = responseData['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);

          // Check inventory status
          final inventoryResponse = await http.post(
            Uri.parse('http://localhost:9000/api/checkInventory'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'token': token,
            }),
          );

          final inventoryData = json.decode(inventoryResponse.body);
          bool isInventoryEmpty = false;

          if (inventoryResponse.statusCode == 200) {
            if (inventoryData['isInventory'] == true) {
              isInventoryEmpty = true;
            } else {
              // Handle inventory data if needed (e.g., show items in inventory)
              isInventoryEmpty = false;
            }
          } else {
            setState(() {
              _errorMessage =
                  inventoryData['message'] ?? 'Error checking inventory.';
            });
          }

          if (!mounted) return;

          // Navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopkeeperDashboard(
                shopkeeperName: responseData['data']['name'],
                hasInventory: !isInventoryEmpty, // Pass inventory status
              ),
            ),
          );
        } else {
          setState(() {
            _errorMessage =
                responseData['message'] ?? 'Login failed. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Connection error. Please check your internet connection.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
                  onPressed: () async {
                    _handleLogin();
                  },
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ShopkeeperSignupScreen()));
                      },
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
