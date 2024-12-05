import 'package:flutter/material.dart';
import '../models/shops.dart';

class ShopSelectionScreen extends StatefulWidget {
  final Function(Shop) onShopSelected;

  const ShopSelectionScreen({
    super.key,
    required this.onShopSelected,
  });

  @override
  State<ShopSelectionScreen> createState() => _ShopSelectionScreenState();
}

class _ShopSelectionScreenState extends State<ShopSelectionScreen> {
  Shop? selectedShop;

  // Dummy data for shops - replace with actual API data
  final List<Shop> nearbyShops = [
    Shop(id: 'SHOP123', name: 'Fresh Mart', address: '123 Main St'),
    Shop(id: 'SHOP456', name: 'Daily Needs', address: '456 Oak Ave'),
    Shop(id: 'SHOP789', name: 'Super Store', address: '789 Pine Rd'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.store_rounded,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Select a Shop',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Choose a nearby shop to browse products',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Dropdown for shop selection
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Shop>(
                  value: selectedShop,
                  hint: Text(
                    'Select a nearby shop',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.primary,
                  ),
                  items: nearbyShops.map((Shop shop) {
                    return DropdownMenuItem<Shop>(
                      value: shop,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            shop.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            'ID: ${shop.id}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Shop? newValue) {
                    setState(() {
                      selectedShop = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Choose button - enabled only when a shop is selected
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedShop != null
                    ? () => widget.onShopSelected(selectedShop!)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('CHOOSE THE SELECTED SHOP'),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
