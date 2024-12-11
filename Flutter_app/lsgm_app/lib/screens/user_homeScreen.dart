import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lsgm_app/models/category.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/shop_selection.dart';
import '../widgets/product_grid.dart';
import '../models/shops.dart';
import '../models/user.dart';
import '../models/prodducts.dart';

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

  // Dummy carousel data
  final List<Product> carouselProducts = [
    Product(
      id: '1',
      name: 'Fresh Organic Carrots',
      weight: '500 gm',
      price: 2.99,
      imagePath: '/api/placeholder/400/300',
    ),
    Product(
      id: '2',
      name: 'Red Bell Peppers',
      weight: '250 gm',
      price: 1.99,
      imagePath: '/api/placeholder/400/300',
    ),
    Product(
      id: '3',
      name: 'Ripe Tomatoes',
      weight: '1 kg',
      price: 3.49,
      imagePath: '/api/placeholder/400/300',
    ),
    Product(
      id: '4',
      name: 'Green Spinach',
      weight: '200 gm',
      price: 1.49,
      imagePath: '/api/placeholder/400/300',
    ),
  ];

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

  Widget _buildCarousel(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          itemCount: carouselProducts.length,
          itemBuilder: (context, index, realIndex) {
            final product = carouselProducts[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
      ],
    );
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

  final List<Category> categories = [
    Category(
      name: 'Fruits',
      imagePath: '/api/placeholder/200/200',
    ),
    Category(
      name: 'Vegetables',
      imagePath: '/api/placeholder/200/200',
    ),
    Category(
      name: 'Dairy',
      imagePath: '/api/placeholder/200/200',
    ),
    Category(
      name: 'Bakery',
      imagePath: '/api/placeholder/200/200',
    ),
    Category(
      name: 'Beverages',
      imagePath: '/api/placeholder/200/200',
    ),
  ];

// Create a new widget for the category section
  Widget _buildCategorySection(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive sizes
    final double circleSize = screenWidth * 0.18; // 18% of screen width
    final double fontSize = screenWidth * 0.03; // 3% of screen width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: circleSize + 40, // Height for circle + text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          category.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: (isShopSelected && selectedShop != null)
            ? CustomScrollView(
                slivers: [
                  // Fixed Header
                  SliverToBoxAdapter(
                    child: Container(
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: IconButton(
                              onPressed: () => _showShopChangeDialog(context),
                              icon: Icon(
                                Icons.store_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showProfileOptions(context),
                            icon: const Icon(Icons.person_outline),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
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
                  ),
                  // Carousel Section
                  SliverToBoxAdapter(
                    child: _buildCarousel(context),
                  ),
                  // Category Section
                  SliverToBoxAdapter(
                    child: _buildCategorySection(context),
                  ),
                  // Product Grid
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ProductGrid(shopId: selectedShop!.id),
                    ),
                  ),
                ],
              )
            : ShopSelectionScreen(onShopSelected: _onShopSelected),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
