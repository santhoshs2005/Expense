
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/new_expense.dart';
import 'package:flutter/material.dart';
// ignore: duplicate_import
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

@override
  State<Expenses> createState() {
   return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List <Expense> _registeredExpenses = [
    Expense( 
      title: 'Flutter course',
      amount: 19.99, 
      date: DateTime.now(),
      category: Category.work,
      ),
      Expense( 
      title: 'cinema',
      amount: 16.69, 
      date: DateTime.now(),
      category: Category.leisure,
      ),
  ];
  

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => NewExpense(onAddExpense: _addExpenses,),
      );
    
  }

  void _addExpenses(Expense expense) {
    setState(() {
       _registeredExpenses.add(expense);
    });
   
  }

  void _removeExpenses(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
     ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted.'),
        action: SnackBarAction(
        label: 'undo', 
        onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        }),
        ),);
  }

  @override
  Widget build(BuildContext context) {
    final width =MediaQuery.of(context).size.width;
    
    Widget maincontent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if(_registeredExpenses.isNotEmpty) {
      maincontent =ExpensesList(
          expenses: _registeredExpenses, 
          onRemoveExpense: _removeExpenses,
          );
    }

  return  Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('Flutter Expense Tracker'),
      actions: [
        IconButton(onPressed: _openAddExpensesOverlay,
         icon:const Icon(Icons.add),
        ),
      ],
    ),
    body: width <600
    ? Column(
      children:  [
        Chart(expenses: _registeredExpenses),
        Expanded(
        child: maincontent
        ),
      ],
    ): Row(children:  [
       Expanded(child: Chart(expenses: _registeredExpenses),
       ), 
        Expanded(
        child: maincontent
        ),
        ]),
  );
  }
}