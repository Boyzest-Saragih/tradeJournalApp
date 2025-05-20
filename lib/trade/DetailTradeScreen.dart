import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Detailtradescreen extends StatefulWidget {
  final int indexTrade;

  const Detailtradescreen({super.key, required this.indexTrade});

  @override
  State<Detailtradescreen> createState() => _DetailtradescreenState();
}

class _DetailtradescreenState extends State<Detailtradescreen> {
  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final trade = tradeProvider.trades[widget.indexTrade];
    return Scaffold(
      appBar: AppBar(
        title: Text("${trade.pair}"),
        backgroundColor: trade.result == "Win" ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Text(
                              "${trade.position}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    trade.position == "Long"
                                        ? Colors.green[500]
                                        : Colors.red[500],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "(x ${trade.leverage})",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Sabtu"), Text("${trade.tradeTime}")],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Entry Price"),
                          Text("\$ ${trade.entryPrice}"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Exit Price"),
                          Text("\$ ${trade.exitPrice}"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Margin"),
                          Text("\$ ${trade.margin}"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("PNL"),
                          Text(
                            "${trade.result == "Win" ? "+" : ""}${trade.pnl}",
                            style: TextStyle(
                              color:
                                  trade.result == "Win"
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),
                  Center(child: Text("TF : ${trade.timeframe}")),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Strategi"), Text(trade.strategy)],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Emosi"), Text(trade.emotion)],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Notes"),
                      Flexible(child: Text(trade.notes)),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Trade sesuai strategi?"),
                      Icon(trade.followedStrategy ? Icons.check : Icons.close),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Risk management ok?"),
                      Icon(
                        trade.properRiskManagement ? Icons.check : Icons.close,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Entry berdasarkan setup?"),
                      Icon(trade.entryBySetup ? Icons.check : Icons.close),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("SL & TP dispiplin?"),
                      Icon(trade.disciplinedSLTP ? Icons.check : Icons.close),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chart Before"),
                  Image.network(trade.beforeChartLink),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chart After"),
                  Image.network(trade.afterChartLink),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
