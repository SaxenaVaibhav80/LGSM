import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsgm_app/screens/shopkeeper_login_screen.dart';
import '../routes/navigation.dart';

class ShopConfirmationScreen extends StatelessWidget {
  final String shopId;
  final String shopName;
  final String shopAddress;

  const ShopConfirmationScreen({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopAddress,
  });

  void _copyShopId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: shopId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shop ID copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Success Title
              Text(
                'Registration Successful!',
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Shop Name and Address
              Text(
                shopName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                shopAddress,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Shop ID Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Your Shop ID',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shopId,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => _copyShopId(context),
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy Shop ID',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please save this ID for future reference',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Important Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'You\'ll need this Shop ID to access your shop dashboard and manage your inventory.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopkeeperLoginScreen()));
                },
                child: const Text('CONTINUE TO DASHBOARD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
