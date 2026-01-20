import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseForm extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategoryChanged;
  final Function() onAddExpense;

  const ExpenseForm({
    super.key,
    required this.amountController,
    required this.selectedCategory,
    required this.categories,
    required this.descriptionController,
    required this.onCategoryChanged,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          controller: amountController,
          decoration: const InputDecoration(
            labelText: "Amount",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: const InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(),
          ),
          items: categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onCategoryChanged(value);
            }
          },
        ),
        const SizedBox(height: 15),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: "Description",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: onAddExpense,
          child: const Text("Add Expense"),
        ),
      ],
    );
  }
}
