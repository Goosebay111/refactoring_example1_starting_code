// STEP 2 pg. 9
// After Extract Method (106), rename some variables to make them more descriptive.

import 'package:intl/intl.dart';

void main() {
  List<Performance> invoiceList = [
    Performance(playID: 'Hamlet', audience: 55),
    Performance(playID: 'As You Like It', audience: 35),
    Performance(playID: 'Othello', audience: 40),
  ];

  List<Play> playList = [
    Play(name: 'Hamlet', type: 'tragedy'),
    Play(name: 'As You Like It', type: 'comedy'),
    Play(name: 'Othello', type: 'tragedy'),
  ];

  Invoices invoices = Invoices(performances: invoiceList);

  Plays plays = Plays(plays: playList);

  print(statement(invoices, plays));
}

String statement(Invoices invoice, Plays plays) {
  var totalAmount = 0;
  var volumeCredits = 0;
  var result = 'Statement for ${invoice.customer}\n';
  var formatter = NumberFormat.simpleCurrency().format;

  int amountFor(Performance perf, Play play) {
    // 1a) change totalAmount to result.
    int result = 0;
    switch (play.type) {
      case 'tragedy':
        result = 40000;
        if (perf.audience > 30) {
          result += 1000 * (perf.audience - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (perf.audience > 20) {
          result += 10000 + 500 * (perf.audience - 20);
        }
        result += 300 * perf.audience;
        break;
      default:
        throw 'unknown type: ${play.type}';
    }
    return result;
  }

  for (Performance perf in invoice.performances) {
    final play = plays.plays.firstWhere((play) => play.name == perf.playID);

    // 2a) This amount method was directly .
    int thisAmount = amountFor(perf, play);

    // add volume credits
    volumeCredits += perf.audience - 30;
    // add extra credit for every ten comedy attendees
    if ('comedy' == play.type) {
      volumeCredits += (perf.audience / 5).floor();
    }
    // print line for this order
    result +=
        ' ${play.name}: ${formatter(thisAmount / 100)} (${perf.audience} seats) \n';
    totalAmount += thisAmount;
  }
  result += 'Amount owed is ${formatter(totalAmount / 100)}\n';
  result += 'You earned $volumeCredits credits\n';
  return result;
}

class Plays {
  Plays({required this.plays});
  List<Play> plays = [];
}

class Play {
  Play({required this.name, required this.type});
  final String name;
  final String type;
}

class Invoices {
  Invoices({required this.performances});
  String customer = 'BigCo';
  List<Performance> performances = [];
}

class Performance {
  Performance({required this.playID, required this.audience});
  String playID;
  int audience;
}
