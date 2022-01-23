// flutter: Statement for BigCo
//  Hamlet: $650.00 (55 seats)
//  As You Like It: $580.00 (35 seats)
//  Othello: $500.00 (40 seats)
// Amount owed is $1,730.00
// You earned 47 credits

import 'package:intl/intl.dart';

String statement(Invoices invoice, Plays plays) {
  var result = 'Statement for ${invoice.customer}\n';

  Play playFor(Performance aPerformance) {
    var result =
        plays.plays.firstWhere((play) => play.name == aPerformance.playID);
    return result;
  }

  int volumeCreditsFor(Performance aPerformance) {
    var result = 0;
    result += aPerformance.audience - 30;
    if ('comedy' == playFor(aPerformance).type) {
      result += (aPerformance.audience / 5).floor();
    }
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

  String usd(aNumber) {
    var result = (NumberFormat.simpleCurrency().format)(aNumber / 100);
    return result;
  }

  totalVolumeCredits() {
    var result = 0;
    for (Performance perf in invoice.performances) {
      result += volumeCreditsFor(perf);
    }
    return result;
  }

  int totalAmount() {
    var result = 0;
    for (Performance perf in invoice.performances) {
      result += amountFor(perf);
    }
    return result;
  }

  for (Performance perf in invoice.performances) {
    result +=
        ' ${playFor(perf).name}: ${usd(amountFor(perf))} (${perf.audience} seats) \n';
  }

  result += 'Amount owed is ${usd(totalAmount())}\n';
  result += 'You earned ${totalVolumeCredits()} credits\n';
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
