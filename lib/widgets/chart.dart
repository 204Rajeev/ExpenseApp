import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/transaction.dart';
import './chart_bar.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List resentTransactions;
  const Chart(recentTransactions, {Key key, this.resentTransactions})
      : super(key: key);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (int i = 0; i < resentTransactions.length; i++) {
        if (resentTransactions[i].date.day == weekDay.day &&
            resentTransactions[i].date.month == weekDay.month &&
            resentTransactions[i].date.year == weekDay.year) {
          totalSum = totalSum + resentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    (totalSpending == 0.0 ? 0.0 : data['amount'] as double) /
                        totalSpending));
          }).toList(),
        ),
      ),
    );
  }
}
