import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lsgm_app/models/category.dart';
import 'package:lsgm_app/models/inventory_item.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  int _getGridCrossAxisCount(double width) {
    if (width > 1200) {
      return 6; // Large screens
    } else if (width > 900) {
      return 5; // Medium-large screens
    } else if (width > 600) {
      return 4; // Medium screens
    } else if (width > 400) {
      return 3; // Small-medium screens
    } else {
      return 2; // Small screens
    }
  }

  // Sample data structure for categories with images
  final List<Category> _categories = [
    Category(
      name: 'All',
      imagePath: 'assets/images/all.png',
    ),
    Category(name: 'Groceries', imagePath: 'assets/images/groceries.png'),
    Category(
      name: 'Dairy',
      imagePath: 'assets/images/dairy.png',
    ),
    Category(
      name: 'Beverages',
      imagePath: 'assets/images/beverages.png',
    ),
    // Add more categories as needed
  ];

  // Sample data structure for inventory items with images
  final Map<String, List<InventoryItem>> _inventoryByCategory = {
    'Groceries': [
      InventoryItem(
        name: 'Rice',
        quantity: 100,
        unit: 'kg',
        pricePerUnit: 2.5,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        imageUrl: 'assets/images/rice.png',
      ),
      InventoryItem(
        name: 'Wheat Flour',
        quantity: 75,
        unit: 'kg',
        pricePerUnit: 1.8,
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        imageUrl: 'assets/images/wheat.png',
      ),
    ],
    'Dairy': [
      InventoryItem(
        name: 'rice 2',
        quantity: 50,
        unit: 'L',
        pricePerUnit: 1.8,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        imageUrl: 'assets/images/milk.png',
      ),
      // Add more dairy items...
    ],
    'Beverages': [
      InventoryItem(
        name: 'Cola',
        quantity: 200,
        unit: 'bottles',
        pricePerUnit: 1.2,
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        imageUrl: 'assets/images/cola.png',
      ),
      // Add more beverage items...
    ],
  };

  List<InventoryItem> _getFilteredItems() {
    List<InventoryItem> items = [];

    if (_selectedCategory == 'All') {
      _inventoryByCategory.forEach((_, categoryItems) {
        items.addAll(categoryItems);
      });
    } else {
      items = _inventoryByCategory[_selectedCategory] ?? [];
    }

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getGridCrossAxisCount(screenWidth);

    final padding = 16.0;
    final spacing = 8.0;
    final availableWidth =
        screenWidth - (padding * 2) - (spacing * (crossAxisCount - 1));
    final cardSize = availableWidth / crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Implement add new item functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Horizontal Category List
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category.name;

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = category.name),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              category.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Item Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1, // Square cards
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: _getFilteredItems().length,
              itemBuilder: (context, index) {
                final item = _getFilteredItems()[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Item Image Background
                      Positioned.fill(
                        child: Image.asset(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Gradient Overlay for better text visibility
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.quantity} ${item.unit}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '\$${item.pricePerUnit.toStringAsFixed(2)}/${item.unit}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons Overlay
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: Colors.white,
                              onPressed: () => _handleEditItem(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.white,
                              onPressed: () => _handleDeleteItem(item),
                            ),
                          ],
                        ),
                      ),

                      // Expiry Badge (if near expiry)
                      if (item.expiryDate != null &&
                          _isNearExpiry(item.expiryDate!))
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Expires ${DateFormat('MMM dd').format(item.expiryDate!)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new item functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleEditItem(InventoryItem item) {
    // Implement edit functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${item.name}'),
        content: const Text('Edit functionality to be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteItem(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${item.name}'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete functionality
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  bool _isNearExpiry(DateTime expiryDate) {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
