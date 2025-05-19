import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:tradejournalapp/trade/DetailTradeScreen.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({super.key});

  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {
  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final trades = tradeProvider.trades;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(4),
        child: ListView.builder(
          itemCount: trades.length,
          itemBuilder: (context, index) {
            final trade = trades[index];
            return InkWell(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> Detailtradescreen(indexTrade: index))
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color:
                      trade.result == "Win"
                          ? Colors.greenAccent[100]
                          : Colors.redAccent[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("${trade.pair} (${trade.timeframe}) | Lev : (${trade.leverage}x)"),
                  subtitle: Text(
                    "Result : ${trade.result} | Emosi : ${trade.emotion}",
                  ),
                  trailing: Text(
                    "\$${trade.pnl.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          trade.result == "Loss"
                              ? const Color.fromARGB(255, 134, 0, 0)
                              : const Color.fromARGB(255, 0, 131, 9),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
