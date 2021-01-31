import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/widget/chart.dart';
import 'package:expense_tracker_app/widget/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:io';
import './models/transaction.dart';
import './widget/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',
            theme: CupertinoThemeData(
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.amber,
              // fontFamily: 'Quicksand',
              // textTheme: ThemeData.light().textTheme.copyWith(
              //       headline6: TextStyle(
              //           fontFamily: 'Oxygen',
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18),
              //       button: TextStyle(color: Colors.white),
              //     ),
              // appBarTheme: AppBarTheme(
              //   textTheme: ThemeData.light().textTheme.copyWith(
              //         headline6: TextStyle(
              //           fontFamily: 'Oxygen',
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              // )
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.amber,
                fontFamily: 'Quicksand',
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                          fontFamily: 'Oxygen',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      button: TextStyle(color: Colors.white),
                    ),
                appBarTheme: AppBarTheme(
                  textTheme: ThemeData.light().textTheme.copyWith(
                        headline6: TextStyle(
                          fontFamily: 'Oxygen',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                )),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 'T1', title: "New T-shirt", amount: 71.80, date: DateTime.now()),
    // Transaction(
    //     id: 'T2', title: "New Shoes", amount: 44.80, date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deletedTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('show Chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracker'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ))
        : AppBar(
            title: Text('Expense Tracker'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
        height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.7,
        child: TransactionList(_userTransactions, _deletedTransaction));
    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(120, 32, 190, 0.91),
          Color.fromRGBO(20, 10, 220, 0.71)
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // isLandscape ? (same meaning that the line bellow)
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
