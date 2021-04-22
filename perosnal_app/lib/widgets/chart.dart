import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perosnal_app/models/transaction.dart';
import 'package:perosnal_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);

  List<Map<String, Object>> get userRecentTransaction {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalsum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year) {
          totalsum += recentTransaction[i].price;
        }
      }
      print(DateFormat.E().format(weekday));
      print(totalsum);
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return userRecentTransaction.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userRecentTransaction);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Flexible(
          fit: FlexFit.tight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: userRecentTransaction.map((data) {
              return ChartBar(
                label: data['day'],
                spendAmount: data['amount'],
                speningPerct: totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
