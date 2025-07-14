import 'dart:math';
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
    if (winrate <= 20) return "Needs Improvement";
    if (winrate <= 35) return "Below Average";
    if (winrate <= 45) return "Average";
    if (winrate <= 55) return "Good";
    if (winrate <= 70) return "Excellent";
    return "Outstanding";
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => _changeMonth(-1),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final allTrades = tradeProvider.trades;
    final filteredTrades = tradeProvider.getTradesForMonth(_selectedDate);

    final totalTrades = allTrades.length;
    final activeTrades = allTrades.where((t) => !t.isDone).length;
    final completedTrades = allTrades.where((t) => t.isDone).length;

    final monthlyTotalTrades = filteredTrades.length;
    final monthlyWinTrades =
        filteredTrades.where((t) => t.result == "Win").length;
    final monthlyLossTrades = monthlyTotalTrades - monthlyWinTrades;
    final monthlyWinRate =
        monthlyTotalTrades > 0
            ? ((monthlyWinTrades / monthlyTotalTrades) * 100).round()
            : 0;
    final monthlyTotalProfit = filteredTrades.fold<double>(
      0,
      (sum, trade) => sum + trade.pnl,
    );

    final dailyPnL = <DateTime, double>{};
    for (final trade in filteredTrades.where(
      (t) => t.isDone && t.tradeTime != null,
    )) {
      final date = trade.tradeTime!;
      final day = DateTime(date.year, date.month, date.day);
      dailyPnL[day] = (dailyPnL[day] ?? 0) + trade.pnl;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatCard(
                    "Total",
                    totalTrades.toString(),
                    Icons.bar_chart,
                    Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    "Active",
                    activeTrades.toString(),
                    Icons.access_time,
                    Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    "Done",
                    completedTrades.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMonthSelector(),
              const SizedBox(height: 24),
              ScaleTransition(
                scale: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceVariant,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Monthly Performance",
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "\$${monthlyTotalProfit.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      monthlyTotalProfit >= 0
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sections: _getSections(
                                          monthlyWinTrades,
                                          monthlyLossTrades,
                                        ),
                                        centerSpaceRadius: 50,
                                        sectionsSpace: 1,
                                        startDegreeOffset:
                                            _animation.value * 360,
                                        pieTouchData: PieTouchData(
                                          touchCallback: (event, response) {},
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Win Rate",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        Text(
                                          "$monthlyWinRate%",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          winrateLabel(monthlyWinRate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLegendItem(
                                    "Wins",
                                    monthlyWinTrades,
                                    Colors.green[400]!,
                                  ),
                                  _buildLegendItem(
                                    "Losses",
                                    monthlyLossTrades,
                                    Colors.red[400]!,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total Trades",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            Text(
                                              monthlyTotalTrades.toString(),
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Avg. Profit",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            Text(
                                              monthlyTotalTrades > 0
                                                  ? "\$${(monthlyTotalProfit / monthlyTotalTrades).toStringAsFixed(2)}"
                                                  : "-",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    monthlyTotalTrades > 0 &&
                                                            (monthlyTotalProfit /
                                                                    monthlyTotalTrades) >=
                                                                0
                                                        ? Colors.green[700]
                                                        : Colors.red[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          "Daily Performance",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            _buildBarChartData(dailyPnL),
                            swapAnimationDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections(int win, int loss) {
    return [
      if (win > 0)
        PieChartSectionData(
          value: win.toDouble(),
          color: Colors.green[400],
          radius: 30,
          showTitle: false,
        ),
      if (loss > 0)
        PieChartSectionData(
          value: loss.toDouble(),
          color: Colors.red[400],
          radius: 30,
          showTitle: false,
        ),
    ];
  }

  BarChartData _buildBarChartData(Map<DateTime, double> dailyPnL) {
    final sortedDates = dailyPnL.keys.toList()..sort();
    final dateToIndex = <DateTime, int>{};
    for (int i = 0; i < sortedDates.length; i++) {
      dateToIndex[sortedDates[i]] = i;
    }

    final barGroups = <BarChartGroupData>[];
    for (final entry in dailyPnL.entries) {
      final index = dateToIndex[entry.key]!;
      final pnl = entry.value;

      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: pnl,
              gradient:
                  pnl >= 0
                      ? LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )
                      : LinearGradient(
                        colors: [Colors.red[400]!, Colors.red[600]!],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
              width: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    final hasData = dailyPnL.values.isNotEmpty;
    final maxVal = hasData ? dailyPnL.values.reduce(max) : 10;
    final minVal = hasData ? dailyPnL.values.reduce(min) : -10;

    return BarChartData(
      maxY: maxVal * 1.3,
      minY: minVal * 1.3,
      barGroups: barGroups,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: hasData ? (maxVal - minVal).abs() / 4 : 5,
        getDrawingHorizontalLine:
            (value) => FlLine(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              strokeWidth: 1,
            ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= sortedDates.length)
                return const SizedBox();
              final date = sortedDates[index];
              return Text(
                DateFormat('MM/dd').format(date),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              );
            },
            interval:
                sortedDates.length > 6
                    ? (sortedDates.length / 6).ceilToDouble()
                    : 1.0,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final date = sortedDates[group.x];
            return BarTooltipItem(
              '${DateFormat('MMM d').format(date)}\nPnL: \$${rod.toY.toStringAsFixed(2)}',
              TextStyle(
                color: rod.toY >= 0 ? Colors.green[800]! : Colors.red[800]!,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
