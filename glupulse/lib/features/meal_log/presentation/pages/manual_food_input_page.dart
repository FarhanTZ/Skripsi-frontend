import 'package:flutter/material.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';

class ManualFoodInputPage extends StatefulWidget {
  const ManualFoodInputPage({super.key});

  @override
  State<ManualFoodInputPage> createState() => _ManualFoodInputPageState();
}

class _ManualFoodInputPageState extends State<ManualFoodInputPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _calController = TextEditingController();
  final _carbController = TextEditingController();
  final _protController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _servingSizeGramsController = TextEditingController();
  final _sodiumMgController = TextEditingController();
  final _glycemicIndexController = TextEditingController();
  final _glycemicLoadController = TextEditingController();
  final _foodCategoryController = TextEditingController();
  final _saturatedFatGramsController = TextEditingController();
  final _monounsaturatedFatGramsController = TextEditingController();
  final _polyunsaturatedFatGramsController = TextEditingController();
  final _cholesterolMgController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _calController.dispose();
    _carbController.dispose();
    _protController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _servingSizeController.dispose();
    _servingSizeGramsController.dispose();
    _sodiumMgController.dispose();
    _glycemicIndexController.dispose();
    _glycemicLoadController.dispose();
    _foodCategoryController.dispose();
    _saturatedFatGramsController.dispose();
    _monounsaturatedFatGramsController.dispose();
    _polyunsaturatedFatGramsController.dispose();
    _cholesterolMgController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final item = MealItem(
      foodName: _nameController.text,
      // foodId null indicates custom/manual food
      quantity: num.tryParse(_qtyController.text) ?? 1,
      calories: num.tryParse(_calController.text),
      carbsGrams: num.tryParse(_carbController.text),
      proteinGrams: num.tryParse(_protController.text),
      fatGrams: num.tryParse(_fatController.text),
      fiberGrams: num.tryParse(_fiberController.text),
      sugarGrams: num.tryParse(_sugarController.text),
      servingSize: _servingSizeController.text.isNotEmpty ? _servingSizeController.text : null,
      servingSizeGrams: num.tryParse(_servingSizeGramsController.text),
      sodiumMg: num.tryParse(_sodiumMgController.text),
      glycemicIndex: num.tryParse(_glycemicIndexController.text),
      glycemicLoad: num.tryParse(_glycemicLoadController.text),
      foodCategory: _foodCategoryController.text.isNotEmpty ? _foodCategoryController.text : null,
      saturatedFatGrams: num.tryParse(_saturatedFatGramsController.text),
      monounsaturatedFatGrams: num.tryParse(_monounsaturatedFatGramsController.text),
      polyunsaturatedFatGrams: num.tryParse(_polyunsaturatedFatGramsController.text),
      cholesterolMg: num.tryParse(_cholesterolMgController.text),
    );

    Navigator.pop(context, item);
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Text(
            'Add Custom Food',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _save,
              child: const Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionContainer(
                      title: 'Basic Info',
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('Food Name *'),
                          validator: (value) => value == null || value.isEmpty ? 'Please enter food name' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _qtyController,
                                decoration: _inputDecoration('Quantity (servings)'),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _foodCategoryController,
                                decoration: _inputDecoration('Category (Optional)'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      title: 'Serving Size',
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _servingSizeController,
                                decoration: _inputDecoration('Unit (e.g. 1 cup)'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _servingSizeGramsController,
                                decoration: _inputDecoration('Weight (grams)'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      title: 'Macros (per serving)',
                      children: [
                        _buildRowFields(_calController, 'Calories (kcal)', _carbController, 'Carbs (g)'),
                        const SizedBox(height: 12),
                        _buildRowFields(_protController, 'Protein (g)', _fatController, 'Fat (g)'),
                        const SizedBox(height: 12),
                        _buildRowFields(_fiberController, 'Fiber (g)', _sugarController, 'Sugar (g)'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      title: 'Fats & Cholesterol',
                      children: [
                        _buildRowFields(_saturatedFatGramsController, 'Saturated Fat (g)', _cholesterolMgController, 'Cholesterol (mg)'),
                        const SizedBox(height: 12),
                        _buildRowFields(_monounsaturatedFatGramsController, 'Monounsat. Fat (g)', _polyunsaturatedFatGramsController, 'Polyunsat. Fat (g)'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      title: 'Others',
                      children: [
                        _buildRowFields(_sodiumMgController, 'Sodium (mg)', _glycemicIndexController, 'Glycemic Index'),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _glycemicLoadController,
                          decoration: _inputDecoration('Glycemic Load'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildRowFields(
    TextEditingController c1,
    String l1,
    TextEditingController c2,
    String l2,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: c1,
            decoration: _inputDecoration(l1),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: c2,
            decoration: _inputDecoration(l2),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
