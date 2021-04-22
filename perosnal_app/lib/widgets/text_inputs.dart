import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextInputs extends StatefulWidget {
  final Function addNewTransaction;
  TextInputs(this.addNewTransaction);

  @override
  _TextInputsState createState() => _TextInputsState();
}

class _TextInputsState extends State<TextInputs> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime selectedDate;
  void pickedDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then(
      (value) {
        setState(() {
          selectedDate = value;
        });
      },
    );
  }

  void submitData() {
    String title = titleController.text;
    double amount = double.parse(amountController.text);

    if (title.isEmpty || amount <= 0 || selectedDate == null) {
      return;
    }
    widget.addNewTransaction(
      title,
      amount,
      selectedDate,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMd().format(selectedDate),
                    ),
                  ),
                  TextButton(
                    onPressed: pickedDate,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  submitData();
                  print(titleController.text);
                  print(amountController.text);
                },
                child: Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
