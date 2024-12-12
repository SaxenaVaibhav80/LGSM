import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _customCategoryController = TextEditingController();
  final _customUnitController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  // Selected values
  String? _selectedCategory;
  String? _selectedUnit;
  DateTime? _expiryDate;
  String? _selectedProductType;

  // States
  bool _isLoading = false;
  bool _isGeneratingImage = false;
  String? _errorMessage;
  String? _imageError;
  bool _showSuccess = false;
  Uint8List? _productImage;

  final List<String> _productTypes = [
    'Packed',
    'Loose',
  ];

  // Lists for dropdowns
  List<String> _categories = [
    'Groceries',
    'Fruits and Vegetables',
    'Dairy',
    'Snacks',
    'Beverages',
    'Household',
    'Personal Care',
    'Baby Care',
    'Health and Wellness',
    'Home and Kitchen',
    'Pet Care',
    'Stationary and Books',
    'Festival and Seasonal',
    'Add New Category...'
  ];

  List<String> _units = [
    'Kg',
    'Grams',
    'Liters',
    'ML',
    'Packets',
    'Pieces',
    'Dozens',
    'Box',
    'Bundle',
    'Add New Unit...'
  ];

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _customCategoryController.dispose();
    _customUnitController.dispose();
    _productDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateProductImage() async {
    if (_productDescriptionController.text.isEmpty) {
      setState(() {
        _imageError = 'Please enter a product description';
      });
      return;
    }

    setState(() {
      _isGeneratingImage = true;
      _imageError = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:9000/api/addStock'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: json.encode({
          'prompt': _productDescriptionController.text,
          'n': 1,
          'size': '256x256',
        }),
      );

      if (response.statusCode == 200) {
        final imageUrl = json.decode(response.body)['data'][0]['url'];
        final imageResponse = await http.get(Uri.parse(imageUrl));

        if (imageResponse.statusCode == 200) {
          setState(() {
            _productImage = imageResponse.bodyBytes;
            _imageError = null;
          });
        } else {
          setState(() {
            _imageError = 'Failed to download image';
          });
        }
      } else {
        setState(() {
          _imageError = 'Failed to generate image. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _imageError = 'Error connecting to image generation service';
      });
    } finally {
      setState(() {
        _isGeneratingImage = false;
      });
    }
  }

  void _showAddCategoryDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Category',
          style: theme.textTheme.titleLarge,
        ),
        content: TextField(
          controller: _customCategoryController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            hintText: 'Enter new category name',
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textCapitalization: TextCapitalization.words,
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_customCategoryController.text.isNotEmpty) {
                setState(() {
                  _categories.insert(
                    _categories.length - 1,
                    _customCategoryController.text,
                  );
                  _selectedCategory = _customCategoryController.text;
                });
                _customCategoryController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddUnitDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Unit',
          style: theme.textTheme.titleLarge,
        ),
        content: TextField(
          controller: _customUnitController,
          decoration: InputDecoration(
            labelText: 'Unit Name',
            hintText: 'Enter new unit of measurement',
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textCapitalization: TextCapitalization.words,
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_customUnitController.text.isNotEmpty) {
                setState(() {
                  _units.insert(
                    _units.length - 1,
                    _customUnitController.text,
                  );
                  _selectedUnit = _customUnitController.text;
                });
                _customUnitController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _showSuccess = false;
      });

      // Prepare the body without try-catch
      String? base64Image;
      if (_productImage != null) {
        base64Image = base64Encode(_productImage!);
      }
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? authToken = pref.getString('authToken');

      final response = await http.post(
        Uri.parse('http://localhost:9000/api/addStock'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productName': _productNameController.text,
          'productType': _selectedProductType,
          'category': _selectedCategory,
          'quantity': double.parse(_quantityController.text),
          'unit': _selectedUnit,
          'pricePerUnit': double.parse(_priceController.text),
          'expiryDate': _expiryDate?.toIso8601String(),
          'productImage': "",
          'token' : authToken,
        }),
      );

      // Handle response status
      if (response.statusCode == 200) {
        setState(() {
          _showSuccess = true;
          // Reset form
          _formKey.currentState!.reset();
          _productNameController.clear();
          _quantityController.clear();
          _priceController.clear();
          _productDescriptionController.clear();
          _selectedCategory = null;
          _selectedUnit = null;
          _selectedProductType = null;
          _expiryDate = null;
          _productImage = null;
        });
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ??
              'Failed to add stock. Please try again.';
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Widget _buildProductTypeDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedProductType,
      decoration: InputDecoration(
        labelText: 'Product Type*',
        prefixIcon: Icon(Icons.inventory_2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _productTypes.map((String type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedProductType = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select product type';
        }
        return null;
      },
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product Image',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.outline),
                image: _productImage != null
                    ? DecorationImage(
                        image: MemoryImage(_productImage!),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              child: _productImage == null
                  ? Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _productDescriptionController,
              decoration: InputDecoration(
                labelText: 'Product Description for Image Generation',
                hintText: 'Describe the product for AI image generation',
                prefixIcon: Icon(Icons.description),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            if (_imageError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _imageError!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isGeneratingImage ? null : _generateProductImage,
              icon: _isGeneratingImage
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.auto_awesome),
              label: Text(
                _isGeneratingImage ? 'Generating...' : 'Generate AI Image',
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
      appBar: AppBar(
        title: Text('Add Stock'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category*',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: category == 'Add New Category...'
                            ? TextStyle(color: theme.colorScheme.primary)
                            : null,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value == 'Add New Category...') {
                      _showAddCategoryDialog();
                    } else {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Add New Category...') {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                // Replace the separate product name and type fields with this Row:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2, // Changed from 3 to 2
                      child: TextFormField(
                        controller: _productNameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name*',
                          prefixIcon: Icon(Icons.inventory),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1, // Changed from 2 to 1
                      child: DropdownButtonFormField<String>(
                        value: _selectedProductType,
                        isExpanded: true, // Add this line
                        decoration: InputDecoration(
                          labelText: 'Type*', // Shortened label
                          prefixIcon: Icon(Icons.inventory_2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _productTypes.map((String type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              overflow: TextOverflow.ellipsis, // Add this line
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedProductType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select type'; // Shortened error message
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                // Product Image Section
                const SizedBox(height: 16),
                _buildImageSection(theme),
                const SizedBox(height: 16),

                // Quantity and Unit Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity*',
                          prefixIcon: Icon(Icons.shopping_cart),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter quantity';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Invalid quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit*',
                          prefixIcon: Icon(Icons.straighten),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _units.map((String unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(
                              unit,
                              style: unit == 'Add New Unit...'
                                  ? TextStyle(color: theme.colorScheme.primary)
                                  : null,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value == 'Add New Unit...') {
                            _showAddUnitDialog();
                          } else {
                            setState(() {
                              _selectedUnit = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'Add New Unit...') {
                            return 'Please select a unit';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price Field
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price per Unit*',
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Invalid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Expiry Date Field
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceVariant,
                  child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Expiry Date (Optional)'),
                    subtitle: Text(
                      _expiryDate != null
                          ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                          : 'Not set',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Success Message
                if (_showSuccess)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      color: Colors.green.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Stock added successfully!',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Submit Button
                FilledButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.add_shopping_cart),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _isLoading ? 'Adding Stock...' : 'Add Stock',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
