import 'package:flutter/material.dart';
import 'package:lsgm_app/widgets/shop_header_info.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/shop_selection.dart';
import '../widgets/product_grid.dart';
import '../models/shops.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShopSelected = false;
  Shop? selectedShop;
  int _selectedIndex = 0;

  // Dummy user - Replace with actual user data
  final user = User(
    id: 'USER123',
    name: 'John Doe',
    email: 'john.doe@example.com',
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onShopSelected(Shop shop) {
    setState(() {
      isShopSelected = true;
      selectedShop = shop;
    });
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildProfileOption(
              context,
              Icons.person_outline,
              'View Profile',
              () {
                Navigator.pop(context);
                // Navigate to profile screen
              },
            ),
            _buildProfileOption(
              context,
              Icons.settings_outlined,
              'Settings',
              () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            _buildProfileOption(
              context,
              Icons.logout,
              'Logout',
              () {
                Navigator.pop(context);
                // Handle logout
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color:
            isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDestructive ? theme.colorScheme.error : null,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showShopChangeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Change Shop',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ShopSelectionScreen(
                onShopSelected: (Shop shop) {
                  _onShopSelected(shop);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isShopSelected && selectedShop != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Shop Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedShop!.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'ID: ${selectedShop!.id}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Change Shop Button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton(
                        onPressed: () => _showShopChangeDialog(context),
                        icon: Icon(
                          Icons.store_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Profile Button
                    IconButton(
                      onPressed: () => _showProfileOptions(context),
                      icon: const Icon(Icons.person_outline),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ProductGrid(shopId: selectedShop!.id),
              ),
            ] else ...[
              ShopSelectionScreen(onShopSelected: _onShopSelected),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
