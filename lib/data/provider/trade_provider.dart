import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeEntry {
  final DateTime tradeTime;
  final String position;
  final double margin;
  final int leverage;
  final double entryPrice;
  final double exitPrice;
  final double stopLoss;
  final double takeProfit;
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
  final bool isDone;

  TradeEntry({
    required this.tradeTime,
    required this.position,
    required this.margin,
    required this.leverage,
    required this.entryPrice,
    required this.exitPrice,
    required this.stopLoss,
    required this.takeProfit,
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
    required this.isDone,
  });

  // ✅ Convert ke JSON
  Map<String, dynamic> toJson() => {
        'tradeTime': tradeTime.toIso8601String(),
        'position': position,
        'margin': margin,
        'leverage': leverage,
        'entryPrice': entryPrice,
        'exitPrice': exitPrice,
        'stopLoss': stopLoss,
        'takeProfit': takeProfit,
        'pnl': pnl,
        'beforeChartLink': beforeChartLink,
        'afterChartLink': afterChartLink,
        'pair': pair,
        'timeframe': timeframe,
        'strategy': strategy,
        'result': result,
        'emotion': emotion,
        'notes': notes,
        'followedStrategy': followedStrategy,
        'properRiskManagement': properRiskManagement,
        'entryBySetup': entryBySetup,
        'disciplinedSLTP': disciplinedSLTP,
        'isDone': isDone,
      };

  // ✅ Convert dari JSON
  factory TradeEntry.fromJson(Map<String, dynamic> json) => TradeEntry(
        tradeTime: DateTime.parse(json['tradeTime']),
        position: json['position'],
        margin: (json['margin'] as num).toDouble(),
        leverage: json['leverage'],
        entryPrice: (json['entryPrice'] as num).toDouble(),
        exitPrice: (json['exitPrice'] as num).toDouble(),
        stopLoss: (json['stopLoss'] as num).toDouble(),
        takeProfit: (json['takeProfit'] as num).toDouble(),
        pnl: (json['pnl'] as num).toDouble(),
        beforeChartLink: json['beforeChartLink'],
        afterChartLink: json['afterChartLink'],
        pair: json['pair'],
        timeframe: json['timeframe'],
        strategy: json['strategy'],
        result: json['result'],
        emotion: json['emotion'],
        notes: json['notes'],
        followedStrategy: json['followedStrategy'],
        properRiskManagement: json['properRiskManagement'],
        entryBySetup: json['entryBySetup'],
        disciplinedSLTP: json['disciplinedSLTP'],
        isDone: json['isDone'],
      );
}

class TradeProvider with ChangeNotifier {
  final List<TradeEntry> _trades = [];

  List<TradeEntry> get trades => List.unmodifiable(_trades);

  // ✅ Tambahkan trade & simpan ke lokal
  void addTrade(TradeEntry entry) {
    _trades.add(entry);
    saveTrades();
    notifyListeners();
  }

  // ✅ Update trade
  void updateTrade(int index, TradeEntry updatedEntry) {
    if (index >= 0 && index < _trades.length) {
      _trades[index] = updatedEntry;
      saveTrades();
      notifyListeners();
    }
  }

  // ✅ Hapus trade
  void removeTrade(int index) {
    if (index >= 0 && index < _trades.length) {
      _trades.removeAt(index);
      saveTrades();
      notifyListeners();
    }
  }

  // ✅ Ambil semua trade pada bulan tertentu
  List<TradeEntry> getTradesForMonth(DateTime month) {
    return _trades.where((trade) =>
        trade.tradeTime.month == month.month &&
        trade.tradeTime.year == month.year).toList();
  }

  // ✅ Simpan semua trade ke SharedPreferences (lokal)
  Future<void> saveTrades() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_trades.map((t) => t.toJson()).toList());
    await prefs.setString('trades', encoded);
  }

  // ✅ Load semua trade dari lokal saat startup
  Future<void> loadTrades() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('trades');
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      _trades.clear();
      _trades.addAll(decoded.map((e) => TradeEntry.fromJson(e)));
      notifyListeners();
    }
  }
}
