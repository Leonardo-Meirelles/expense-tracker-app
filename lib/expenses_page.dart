import 'package:flutter/material.dart';

import 'models/expense_model.dart';
import 'widgets/chart/chart.dart';
import 'widgets/expenses-list/expenses_list.dart';
import 'widgets/new_expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<ExpenseModel> _expensesList = [];

  void _openAddExpensesOverlay() {
    // Built-in to Flutter to show bottom modal
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (cxt) => NewExpense(onAddExpense: addExpense),
    );
  }

  void addExpense(ExpenseModel expense) {
    setState(() {
      _expensesList.add(expense);
    });
  }

  void removeExpense(ExpenseModel expense) {
    final expenseIndex = _expensesList.indexOf(expense);

    setState(() {
      _expensesList.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expensesList.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker App',
          style: TextStyle(
              // color: Colors.white,
              ),
        ),
        // backgroundColor: Colors.black,
        actions: [
          IconButton(
            // color: Colors.white,
            onPressed: () => _openAddExpensesOverlay(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _expensesList.isEmpty
          ? const Center(child: Text('Create a new expense!'))
          : Column(
              children: [
                Chart(expenses: _expensesList),
                Expanded(
                  child: ExpensesList(
                    expenses: _expensesList,
                    onRemoveExpense: removeExpense,
                  ),
                )
              ],
            ),
    );
  }
}
