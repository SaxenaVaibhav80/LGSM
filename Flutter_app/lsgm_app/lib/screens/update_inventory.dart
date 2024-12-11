import 'package:flutter/material.dart';

import 'dart:io';

import 'package:intl/intl.dart';

class InventoryUpdatePage extends StatefulWidget {
  const InventoryUpdatePage({super.key});

  @override
  _InventoryUpdatePageState createState() => _InventoryUpdatePageState();
}

class _InventoryUpdatePageState extends State<InventoryUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedProduct;
  File? _newImage;
  DateTime? _expiryDate;

  // Form controllers
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  // Form values
  String _productType = 'Packed';
  String _unit = 'Units';

  // Sample data - Replace with actual API data
  final List<String> _products = ['Product 1', 'Product 2', 'Product 3'];
  final List<String> _productTypes = ['Packed', 'Loose'];
  final List<String> _units = ['Units', 'Kg', 'g', 'L', 'mL'];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails(String productId) async {
    setState(() => _isLoading = true);
    try {
      // TODO: Fetch product details from API
      // Simulated API call
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _nameController.text = 'Sample Product';
        _quantityController.text = '100';
        _priceController.text = '10.99';
        _productType = 'Packed';
        _unit = 'Units';
        _expiryDate = DateTime.now().add(const Duration(days: 30));
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load product details');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateInventory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // TODO: Send update request to API
      await Future.delayed(const Duration(seconds: 2));
      _showSuccessSnackBar('Inventory updated successfully');
      _resetForm();
    } catch (e) {
      _showErrorSnackBar('Failed to update inventory');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    setState(() {
      _selectedProduct = null;
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
      _productType = 'Packed';
      _unit = 'Units';
      _expiryDate = null;
      _newImage = null;
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Inventory'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Product',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedProduct,
                              decoration: const InputDecoration(
                                hintText: 'Select a product to update',
                              ),
                              items: _products.map((product) {
                                return DropdownMenuItem(
                                  value: product,
                                  child: Text(product),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedProduct = value);
                                  _loadProductDetails(value);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a product';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedProduct != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Details',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Product Name',
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _productType,
                                decoration: const InputDecoration(
                                  labelText: 'Product Type',
                                ),
                                items: _productTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _productType = value);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: _quantityController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter quantity';
                                        }
                                        if (double.tryParse(value) == null ||
                                            double.parse(value) <= 0) {
                                          return 'Please enter a valid quantity';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _unit,
                                      decoration: const InputDecoration(
                                        labelText: 'Unit',
                                      ),
                                      items: _units.map((unit) {
                                        return DropdownMenuItem(
                                          value: unit,
                                          child: Text(unit),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() => _unit = value);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Price per Unit',
                                  prefixText: '\$',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter price';
                                  }
                                  if (double.tryParse(value) == null ||
                                      double.parse(value) <= 0) {
                                    return 'Please enter a valid price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Expiry Date'),
                                subtitle: Text(
                                  _expiryDate != null
                                      ? DateFormat('MMM dd, yyyy')
                                          .format(_expiryDate!)
                                      : 'Not set',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _updateInventory,
                                      icon: const Icon(Icons.save),
                                      label: const Text('Update Inventory'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: _resetForm,
                                      child: const Text('Reset'),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.error,
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
                  ],
                ),
              ),
            ),
    );
  }
}
