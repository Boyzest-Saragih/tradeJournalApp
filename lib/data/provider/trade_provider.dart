import 'package:flutter/foundation.dart';

class TradeEntry {
  final DateTime tradeTime;
  final double margin;
  final double entryPrice;
  final double exitPrice;
  final String chartLink;
  final String pair;
  final String timeframe;
  final String strategy;
  final String result;
  final String emotion;
  final String notes;

  final bool followedStrategy;
  final bool properRiskManagement;
  final bool entryBySetup;
  final bool disciplinedSLTP;

  TradeEntry({
    required this.tradeTime,
    required this.margin,
    required this.entryPrice,
    required this.exitPrice,
    required this.chartLink,
    required this.pair,
    required this.timeframe,
    required this.strategy,
    required this.result,
    required this.emotion,
    required this.notes,
    required this.followedStrategy,
    required this.properRiskManagement,
    required this.entryBySetup,
    required this.disciplinedSLTP,
  });
}

class TradeProvider with ChangeNotifier {
  final List<TradeEntry> _trades = [
    TradeEntry(
      tradeTime: DateTime.parse("2025-05-01 10:30:00"),
      margin: 20,
      entryPrice: 0.45,
      exitPrice: 0.60,
      chartLink: "https://tradingview.com/chart/xrp-sample",
      pair: "XRP/USDT",
      timeframe: "15m",
      strategy: "FVG + CHoCH + OB",
      result: "Win",
      emotion: "Tenang",
      notes: "Entry setelah price kembali ke OB. Ada rejeksi bagus.",
      followedStrategy: true,
      properRiskManagement: true,
      entryBySetup: true,
      disciplinedSLTP: true,
    ),
    TradeEntry(
      tradeTime: DateTime.parse("2025-05-03 15:45:00"),
      margin: -10,
      entryPrice: 0.52,
      exitPrice: 0.46,
      chartLink: "https://tradingview.com/chart/xrp-loss",
      pair: "XRP/USDT",
      timeframe: "15m",
      strategy: "Breakout False + Retest",
      result: "Loss",
      emotion: "Ragu",
      notes: "Masuk terlalu cepat, belum ada validasi volume.",
      followedStrategy: false,
      properRiskManagement: false,
      entryBySetup: false,
      disciplinedSLTP: true,
    ),
  ];

  List<TradeEntry> get trades => _trades;

  void addTrade(TradeEntry entry) {
    _trades.add(entry);
    notifyListeners();
  }

  void removeTrade(int index) {
    _trades.removeAt(index);
    notifyListeners();
  }

  void updateTrade(int index, TradeEntry updatedEntry) {
    _trades[index] = updatedEntry;
    notifyListeners();
  }
}
