import 'package:flutter/material.dart';
import 'package:lsgm_app/models/prodducts.dart';

class ProductGrid extends StatelessWidget {
  final String shopId;

  const ProductGrid({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 220.0 : 160.0;
    // Reduced card height to prevent overflow
    final cardHeight = screenWidth > 600 ? 250.0 : 216.0;
    final cardPadding = screenWidth > 600 ? 16.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Added to prevent expansion
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: cardPadding,
            vertical: cardPadding / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Products',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: cardPadding),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = Product(
                id: '1',
                name: 'Beetroot',
                weight: '500 gm',
                price: 17.29,
                imagePath: '/api/placeholder/400/300',
              );
              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(right: cardPadding),
                child: _buildProductCard(
                  context,
                  product,
                  screenWidth,
                  cardHeight,
                ),
              );
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    double screenWidth,
    double cardHeight,
  ) {
    final theme = Theme.of(context);
    final isTabletOrLarger = screenWidth > 600;

    // Adjusted sizes
    final titleFontSize = isTabletOrLarger ? 16.0 : 13.0;
    final weightFontSize = isTabletOrLarger ? 14.0 : 11.0;
    final priceFontSize = isTabletOrLarger ? 16.0 : 13.0;
    final iconSize = isTabletOrLarger ? 22.0 : 18.0;
    final cardPadding = isTabletOrLarger ? 12.0 : 8.0;

    // Adjusted content heights
    final imageHeight = cardHeight * 0.48;
    final contentHeight = cardHeight * 0.48;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: imageHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                product.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(
            height: contentHeight,
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: cardPadding / 4),
                      Text(
                        product.weight,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: weightFontSize,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: priceFontSize,
                        ),
                      ),
                      Material(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.all(cardPadding / 2),
                            child: Icon(
                              Icons.add,
                              size: iconSize,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
