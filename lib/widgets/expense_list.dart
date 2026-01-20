import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
  });

  final List<Expense> expenses;
  final Function(int) onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 30, thickness: 2),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Expense List:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: expenses.isEmpty
              ? const Center(child: Text("No expenses added yet."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              "${expenses[index].amount} EGP - ${expenses[index].category}",
                            ),
                            subtitle: Text(expenses[index].description ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                onDeleteExpense(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Total Expense: ${(expenses.fold<double>(0, (sum, item) => sum + item.amount)).toStringAsFixed(2)} EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
