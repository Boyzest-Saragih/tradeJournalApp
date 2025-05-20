import 'package:flutter/foundation.dart';

class TradeEntry {
  final DateTime tradeTime;
  final String position;
  final double margin;
  final int leverage;
  final double entryPrice;
  final double exitPrice;
  final double pnl;
  final String beforeChartLink;
  final String afterChartLink;
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
    required this.position,
    required this.margin,
    required this.leverage,
    required this.entryPrice,
    required this.exitPrice,
    required this.pnl,
    required this.beforeChartLink,
    required this.afterChartLink,
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
      position: "Long",
      margin: 20,
      leverage: 10,
      entryPrice: 0.45,
      exitPrice: 0.60,
      pnl: 10,
      beforeChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
      afterChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
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
      position: "Short",
      margin: 10,
      leverage: 10,
      entryPrice: 0.52,
      exitPrice: 0.46,
      pnl: -10,
      beforeChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
      afterChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
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
    TradeEntry(
      tradeTime: DateTime.parse("2025-05-03 15:45:00"),
      position: "Short",
      margin: 10,
      leverage: 10,
      entryPrice: 0.52,
      exitPrice: 0.46,
      pnl: 10,
      beforeChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
      afterChartLink: "https://s3.tradingview.com/snapshots/j/JYZL5Ywv.png",
      pair: "XRP/USDT",
      timeframe: "15m",
      strategy: "Breakout False + Retest",
      result: "Win",
      emotion: "Confidence",
      notes: "Masuk terlalu cepat, belum ada validasi volume ",
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
