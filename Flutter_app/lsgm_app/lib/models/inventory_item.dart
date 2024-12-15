class InventoryItem {
  final String name;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final DateTime? expiryDate;
  final String imageUrl;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    this.expiryDate,
    required this.imageUrl,
  });
}
