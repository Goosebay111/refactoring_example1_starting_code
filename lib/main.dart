// STEP 8 pg. 15
//

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

  Play playFor(Performance aPerformance) {
    var result =
        plays.plays.firstWhere((play) => play.name == aPerformance.playID);
    return result;
  }

  int amountFor(Performance aPerformance) {
    int result = 0;
    switch (playFor(aPerformance).type) {
      case 'tragedy':
        result = 40000;
        if (aPerformance.audience > 30) {
          result += 1000 * (aPerformance.audience - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (aPerformance.audience > 20) {
          result += 10000 + 500 * (aPerformance.audience - 20);
        }
        result += 300 * aPerformance.audience;
        break;
      default:
        throw 'unknown type: ${playFor(aPerformance).type}';
    }
    return result;
  }

  for (Performance perf in invoice.performances) {
    volumeCredits += perf.audience - 30;
    if ('comedy' == playFor(perf).type) {
      volumeCredits += (perf.audience / 5).floor();
    }
    result +=
        ' ${playFor(perf).name}: ${formatter(amountFor(perf) / 100)} (${perf.audience} seats) \n';
    totalAmount += amountFor(perf);
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
