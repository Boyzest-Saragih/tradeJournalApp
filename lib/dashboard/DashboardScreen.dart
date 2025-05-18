import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final int jumlhTrade = 100;
  final int margin = 300;
  final int win = 10;
  final int losses = 90;
  final int profit = 10;
  final int lose = 90;

  String winrateLabel(int winrate) {
    if (winrate <= 20) return "Very Bad";
    if (winrate <= 35) return "Bad";
    if (winrate <= 45) return "Average";
    if (winrate <= 55) return "Good";
    if (winrate <= 70) return "Very Good";
    return "Excellent";
  }

  @override
  Widget build(BuildContext context) {
    final int winrate = ((win / jumlhTrade) * 100).round();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\$$margin",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Divider(color: Colors.black),

            const SizedBox(height: 20),


            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          // swapAnimationDuration: const Duration(
                          //   milliseconds: 800,
                          // ),
                          // swapAnimationCurve: Curves.easeInOut,
                          PieChartData(
                            sections: _getSections(profit, lose),
                            centerSpaceRadius: 70,
                            sectionsSpace: 2,
                            // pieTouchData: PieTouchData(
                            //   enabled: true,
                            //   touchCallback: (event, response) {
                            //     if (response != null &&
                            //         response.touchedSection != null) {
                            //       final index =
                            //           response
                            //               .touchedSection!
                            //               .touchedSectionIndex;
                            //       debugPrint(index == 1 ? "lose" : "profit");
                            //     }
                            //   },
                            // ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              winrateLabel(winrate).toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '$winrate%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              '$jumlhTrade total trade',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoTile(title: "Total Trade", value: "$jumlhTrade"),
                      InfoTile(title: "Total Win", value: "$win"),
                      InfoTile(title: "Total Loss", value: "$losses"),
                      InfoTile(title: "Profit Trade", value: "$profit"),
                      InfoTile(title: "Losing Trade", value: "$lose"),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections(int profit, int lose) {
    return [
      if (profit > 0)
        PieChartSectionData(
          value: profit.toDouble(),
          color: Colors.green,
          radius: 40,
          showTitle: false,
        ),
      if (lose > 0)
        PieChartSectionData(
          value: lose.toDouble(),
          color: Colors.red,
          radius: 40,
          showTitle: false,
        ),
    ];
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text("- $title:", style: const TextStyle(fontSize: 14)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
