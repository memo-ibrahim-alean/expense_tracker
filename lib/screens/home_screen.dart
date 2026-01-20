import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_form.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box box = Hive.box('expenses');
  List<Expense> expenses = [];
  final List<String> categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Other',
  ];

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Food';

  void loadExpenses() {
    final savedExpenses = box.get('expenses');
    if (savedExpenses != null) {
      setState(() {
        expenses = (savedExpenses as List).map((e) {
          return Expense.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      });
    } else {
      expenses = [];
    }
  }

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Expense Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            ExpenseForm(
              amountController: amountController,
              selectedCategory: selectedCategory,
              categories: categories,
              descriptionController: descriptionController,
              onCategoryChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              onAddExpense: () {
                if (amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter an amount")),
                  );
                  return;
                }

                if (descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a description")),
                  );
                  return;
                }

                try {
                  setState(() {
                    expenses.add(
                      Expense(
                        id: DateTime.now().toString(),
                        amount: double.parse(amountController.text),
                        category: selectedCategory,
                        date: DateTime.now(),
                        description: descriptionController.text,
                      ),
                    );
                    box.put(
                      'expenses',
                      expenses.map((e) => e.toMap()).toList(),
                    );
                    amountController.clear();
                    descriptionController.clear();
                    selectedCategory = categories[0];
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid number"),
                    ),
                  );
                  return;
                }
              },
            ),
            Expanded(
              child: ExpenseList(
                expenses: expenses,
                onDeleteExpense: (index) {
                  setState(() {
                    expenses.removeAt(index);
                    box.put(
                      'expenses',
                      expenses.map((e) => e.toMap()).toList(),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
