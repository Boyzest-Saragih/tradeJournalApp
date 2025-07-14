import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:tradejournalapp/trade/UpdateTradeScreen.dart';
import 'package:tradejournalapp/trade/addTradeForm.dart';

class Activetradescreen extends StatefulWidget {
  const Activetradescreen({super.key});

  @override
  State<Activetradescreen> createState() => _ActivetradescreenState();
}

class _ActivetradescreenState extends State<Activetradescreen> {
  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final activeTrades =
        tradeProvider.trades.where((trade) => !trade.isDone).toList();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 5),
          Expanded(
            child:
                activeTrades.isEmpty
                    ? const Center(child: Text("No active trades yet."))
                    : ListView.builder(
                      itemCount: activeTrades.length,
                      itemBuilder: (BuildContext context, int index) {
                        final trade = activeTrades[index];
                        return _buildSlidableCard(context, trade, index);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TradeFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSlidableCard(BuildContext context, TradeEntry trade, int index) {
    return Slidable(
      key: ValueKey(trade.tradeTime.toIso8601String()),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    final provider = Provider.of<TradeProvider>(
                      context,
                      listen: false,
                    );
                    final realIndex = provider.trades.indexOf(trade);
                    return UpdateTradeScreen(
                      tradeIndex: realIndex,
                      result: "Win",
                    );
                  },
                ),
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'TP',
          ),
          SlidableAction(
            onPressed: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    final provider = Provider.of<TradeProvider>(
                      context,
                      listen: false,
                    );
                    final realIndex = provider.trades.indexOf(trade);
                    return UpdateTradeScreen(
                      tradeIndex: realIndex,
                      result: "Loss",
                    );
                  },
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'SL',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(
            trade.pair,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Position: ${trade.position} | Entry: ${trade.entryPrice}"),
              Text("SL: ${trade.stopLoss} | TP: ${trade.takeProfit}"),
            ],
          ),
          trailing: Icon(
            trade.position.toLowerCase() == 'long'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color:
                trade.position.toLowerCase() == 'long'
                    ? Colors.green
                    : Colors.red,
          ),
        ),
      ),
    );
  }
}
