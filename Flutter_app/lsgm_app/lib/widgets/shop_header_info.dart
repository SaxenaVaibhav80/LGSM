import 'package:flutter/material.dart';
import 'package:lsgm_app/models/shops.dart';


class ShopInfoHeader extends StatelessWidget {
  final Shop shop;

  const ShopInfoHeader({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shop.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ID: ${shop.id}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: theme.colorScheme.surfaceVariant,
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                // Navigate to profile
                // Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}
