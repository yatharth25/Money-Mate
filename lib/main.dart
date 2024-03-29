import 'package:ExpenseTracker/widgets/chart.dart';
import 'package:ExpenseTracker/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Mate',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              // ignore: deprecated_member_use
              title: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                // ignore: deprecated_member_use
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'Guitar',
    //   amount: 4000.00,
    //   dateTime: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Earphones',
    //   amount: 1299.00,
    //   dateTime: DateTime.now(),
    // ),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _usertransaction.where((tx) {
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String ttitle, double tamount, DateTime tDate) {
    final newtransac = Transaction(
        id: DateTime.now().toString(),
        title: ttitle,
        amount: tamount,
        dateTime: tDate);
    setState(() {
      _usertransaction.add(newtransac);
    });
  }

  void _startNewTransc(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Money Mate'),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
            icon: Icon(Icons.add), onPressed: () => _startNewTransc(context))
      ],
    );
    final trnsListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_usertransaction, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
            if (!landscape)
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!landscape) trnsListWidget,
            if (landscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : trnsListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startNewTransc(context),
      ),
    );
  }
}
