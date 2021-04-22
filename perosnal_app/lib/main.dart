import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:perosnal_app/widgets/chart.dart';
import 'package:perosnal_app/widgets/text_inputs.dart';
import 'package:perosnal_app/widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:intl/intl.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.yellow,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Opensans',
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Opensans',
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   price: 30,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't1',
    //   title: 'Grocessary',
    //   price: 30,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
      title: title,
      price: amount,
      date: selectedDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void deleteTx(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void startNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TextInputs(addNewTransaction);
      },
      elevation: 5,
      backgroundColor: Colors.purple,
    );
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expense'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            startNewTransaction(context);
          },
        )
      ],
    );
    final txList = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transaction: _userTransactions,
        deleteTx: deleteTx,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Display Chart
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart '),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        print(_showChart);

                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
            if (!isLandScape)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransaction),
              ),
            if (!isLandScape) txList,
            if (isLandScape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransaction),
                    )
                  : txList
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          startNewTransaction(context);
        },
      ),
    );
  }
}
