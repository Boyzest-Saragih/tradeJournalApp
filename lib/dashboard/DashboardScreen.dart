import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:intl/intl.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String winrateLabel(int winrate) {
    if (winrate <= 20) return "Very Bad";
    if (winrate <= 35) return "Bad";
    if (winrate <= 45) return "Average";
    if (winrate <= 55) return "Good";
    if (winrate <= 70) return "Very Good";
    return "Excellent";
  }

  void _changeMonth(int offset) {
    setState(() {
      final newMonth = _selectedDate.month + offset;
      final newYear =
          _selectedDate.year + (newMonth > 12 ? 1 : (newMonth < 1 ? -1 : 0));
      _selectedDate = DateTime(newYear, newMonth.clamp(1, 12));
    });
  }

  Widget _buildMonthSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final filteredTrades = tradeProvider.getTradesForMonth(_selectedDate);

    final totalTrades = filteredTrades.length;
    final winTrades = filteredTrades.where((t) => t.result == "Win").length;
    final lossTrades = totalTrades - winTrades;
    final winRate =
        totalTrades > 0 ? ((winTrades / totalTrades) * 100).round() : 0;
    final totalProfit = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.pnl,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Monthly Performance",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPerformanceChart(
                              winTrades,
                              lossTrades,
                            ),
                          ),
                          Expanded(
                            child: _buildStatsList(
                              totalTrades: totalTrades,
                              winTrades: winTrades,
                              lossTrades: lossTrades,
                              totalProfit: totalProfit,
                              winRate: winRate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart(int win, int loss) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: _getSections(win, loss),
          centerSpaceRadius: 50,
          sectionsSpace: 2,
          startDegreeOffset: _animation.value * 360,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildStatsList({
    required int totalTrades,
    required int winTrades,
    required int lossTrades,
    required double totalProfit,
    required int winRate,
  }) {
    return Column(
      children: [
        _buildStatTile("Total Trades", totalTrades.toString(), Icons.list_alt),
        _buildStatTile("Win Rate", "$winRate%", Icons.percent),
        _buildStatTile(
          "Winning Trades",
          winTrades.toString(),
          Icons.trending_up,
        ),
        _buildStatTile(
          "Losing Trades",
          lossTrades.toString(),
          Icons.trending_down,
        ),
        _buildStatTile(
          "Total Profit",
          "\$${totalProfit.toStringAsFixed(2)}",
          totalProfit >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections(int win, int loss) {
    return [
      if (win > 0)
        PieChartSectionData(
          value: win.toDouble(),
          color: Colors.green[400],
          radius: 30 + (_animation.value * 10),
          title: '$win',
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      if (loss > 0)
        PieChartSectionData(
          value: loss.toDouble(),
          color: Colors.red[400],
          radius: 30 + (_animation.value * 10),
          title: '$loss',
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
    ];
  }

  Widget _buildStatTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blueGrey[600]),
      ),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
