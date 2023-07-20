import 'package:flutter/material.dart';

void main() {
  runApp(BudgetApp());
}

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedCategory = 'Expenses';
  List<String> categories = ['Expenses', 'Salary', 'Stats'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.list),
          onSelected: (String value) {
            if (value == 'Expenses') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseScreen(),
                ),
              );
            } else {
              setState(() {
                selectedCategory = value;
              });
            }
          },
          itemBuilder: (BuildContext context) {
            return categories.map((String category) {
              return PopupMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Money Spent in this Month', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text(': Rs 12000', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Information')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child:
                    Text('User Name: Anshika', style: TextStyle(fontSize: 24))),
            Align(
                alignment: Alignment.topLeft,
                child: Text('Age: 21', style: TextStyle(fontSize: 24))),
            Align(
                alignment: Alignment.topLeft,
                child: Text('Phone Number: 9136114546',
                    style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Expense> expenses = [];

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'List of Expenses',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index].value),
                  subtitle: Text(expenses[index].description),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddExpensePopup(
                    onExpenseAdded: addExpense,
                  );
                },
              );
            },
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}

class AddExpensePopup extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  AddExpensePopup({required this.onExpenseAdded});

  @override
  _AddExpensePopupState createState() => _AddExpensePopupState();
}

class _AddExpensePopupState extends State<AddExpensePopup> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  void showDatePickerDialog(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
        });
      }
    });
  }

  @override
  void dispose() {
    valueController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: valueController,
            decoration: InputDecoration(
              labelText: 'Expense Value',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Date: ',
                style: TextStyle(fontSize: 16),
              ),
              InkWell(
                onTap: () => showDatePickerDialog(context),
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String value = valueController.text.trim();
              String description = descriptionController.text.trim();

              if (value.isNotEmpty && description.isNotEmpty) {
                Expense expense = Expense(
                  value: value,
                  description: description,
                  date: selectedDate,
                );

                widget.onExpenseAdded(expense);

                Navigator.pop(context);
              }
            },
            child: Text('Save Expense'),
          ),
        ],
      ),
    );
  }
}

class Expense {
  final String value;
  final String description;
  final DateTime date;

  Expense({
    required this.value,
    required this.description,
    required this.date,
  });
}
