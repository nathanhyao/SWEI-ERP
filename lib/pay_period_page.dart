import 'package:flutter/material.dart';
import 'package:shay_app/models/pay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shay_app/services/globals.dart' as globals;

class PayPeriodPage extends StatefulWidget {
  const PayPeriodPage({super.key});

  @override
  State<PayPeriodPage> createState() => _PayPeriodPageState();
}

class _PayPeriodPageState extends State<PayPeriodPage> {
  final List<Pay> _pay = [];

  Future fetchPay() async {
    var response = await http.post(
      Uri.parse(globals.httpURL),
      body: json.encode(
        {
          'key': 'pay_fetch',
          'email': globals.currentUser.email,
        },
      ),
    );
    // debugPrint(response.body);

    // Parse into Pay objects, store into 'pay' list
    var pay = <Pay>[];

    if (response.statusCode == 200) {
      // http returns 200 means OK
      debugPrint('Fetching Pay: http.get OK');

      var payPeriodsJson = json.decode(response.body);
      for (var payPeriodJson in payPeriodsJson) {
        pay.add(Pay.fromJson(payPeriodJson));
      }
    } else {
      debugPrint('Fetching Pay: http.get BAD');
    }

    return pay;
  }

  @override
  void initState() {
    fetchPay().then((value) {
      // fetchPay() is asynchronous. Use .then() to wait for it to finish
      setState(() {
        _pay.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Your Pay Periods'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var title = _pay[index].week;
            var isInProgress = _pay[index].isInProgress;
            // var assignedName = _pay[index].assignedName;
            var payPeriodHours = _pay[index].payPeriodHours;
            var income = _pay[index].income;

            return Card(
              elevation: 2.5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.payment,
                        size: 35,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            isInProgress ? 'Completed' : 'In Progress',
                          ),
                          Text(
                            'Hours worked: $payPeriodHours',
                          ),
                          Text(
                            'Income for pay period: $income',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _pay.length,
        ),
      ),
    );
  }
}
