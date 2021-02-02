import 'package:expense_tracker_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

// decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(35),
//         border: Border.all(color: Colors.white.withOpacity(0.08)),
//         gradient: LinearGradient(colors: [
//           Colors.white.withOpacity(0.2),
//           Colors.white.withOpacity(0.05),
//         ]),
//       ),

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () {
                  deleteTx(transaction);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deleteTx(transaction);
                },
              ),
      ),
    );
    // Here bellow another style for the transaction list, take the one you prefer !!
    // return Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         margin:
    //             EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //               color: Theme.of(context).primaryColor, width: 2),
    //         ),
    //         padding: EdgeInsets.all(10),
    //         child: Text(
    //           '\$${transactions[index].amount.toStringAsFixed(2)}',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ),
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             transactions[index].title,
    //             style: Theme.of(context).textTheme.headline6,
    //           ),
    //           Text(
    //             DateFormat('dd-MM-yyyy')
    //                 .format(transactions[index].date),
    //             style: TextStyle(color: Colors.grey, fontSize: 13),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
