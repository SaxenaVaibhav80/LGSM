import 'package:flutter/material.dart';
import 'package:lsgm_app/screens/add_stock.dart';
import 'package:lsgm_app/screens/update_inventory.dart';
import 'package:lsgm_app/widgets/bottom_navBar_shopkeeper.dart';

class ShopkeeperDashboard extends StatefulWidget {
  final String shopkeeperName;
  final bool hasInventory;

  const ShopkeeperDashboard({
    super.key,
    required this.shopkeeperName,
    required this.hasInventory,
  });

  @override
  State<ShopkeeperDashboard> createState() => _ShopkeeperDashboardState();
}

class _ShopkeeperDashboardState extends State<ShopkeeperDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildInventoryPage();
      case 1:
        return _buildOrdersPage();
      case 2:
        return _buildDebtPage();
      default:
        return _buildInventoryPage();
    }
  }

  Widget _buildInventoryPage() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.store,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inventory Management',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.add_box,
                      color: theme.colorScheme.onPrimary,
                    ),
                    label: Text(
                      'Add Stock to Inventory',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddStockPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                  if (widget.hasInventory) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.edit_note,
                        color: theme.colorScheme.onSecondary,
                      ),
                      label: Text(
                        'Update Inventory',
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryUpdatePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersPage() {
    return const Center(
      child: Text('Orders Page - Coming Soon'),
    );
  }

  Widget _buildDebtPage() {
    return const Center(
      child: Text('Debt Page - Coming Soon'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    widget.shopkeeperName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, size: 32),
              onPressed: () {
                // Handle profile button tap
              },
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _getPage(),
      ),
      bottomNavigationBar: ShopkeeperBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
