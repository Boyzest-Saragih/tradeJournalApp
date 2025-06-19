import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:intl/intl.dart';

class Detailtradescreen extends StatefulWidget {
  final int indexTrade;

  const Detailtradescreen({super.key, required this.indexTrade});

  @override
  State<Detailtradescreen> createState() => _DetailtradescreenState();
}

class _DetailtradescreenState extends State<Detailtradescreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final trade = tradeProvider.trades[widget.indexTrade];
    final isWin = trade.result == "Win";
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(trade.pair),
        backgroundColor: isWin ? Colors.green[800] : Colors.red[800],
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildInfoCard(
                title: 'Trade Details',
                children: [
                  _buildDetailRow(
                    'Position',
                    '${trade.position} (x${trade.leverage})',
                    color:
                        trade.position == "Long"
                            ? Colors.green[800]
                            : Colors.red[800],
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    'Date & Time',
                    dateFormat.format(trade.tradeTime),
                    icon: Icons.calendar_today,
                  ),
                  _buildDivider(),
                  _buildDualDetail(
                    leftLabel: 'Entry Price',
                    leftValue: '\$${trade.entryPrice.toStringAsFixed(2)}',
                    rightLabel: 'Exit Price',
                    rightValue: '\$${trade.exitPrice.toStringAsFixed(2)}',
                  ),
                  _buildDivider(),
                  _buildDualDetail(
                    leftLabel: 'Margin',
                    leftValue: '\$${trade.margin.toStringAsFixed(2)}',
                    rightLabel: 'PNL',
                    rightValue:
                        '${isWin ? '+' : ''}\$${trade.pnl.toStringAsFixed(2)}',
                    rightColor: isWin ? Colors.green[800] : Colors.red[800],
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    'Timeframe',
                    trade.timeframe,
                    icon: Icons.timelapse,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Trade Analysis',
                children: [
                  _buildDetailRow(
                    'Strategy',
                    trade.strategy,
                    icon: Icons.auto_awesome,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    'Emotion',
                    trade.emotion,
                    icon: Icons.psychology,
                    color: Colors.orange[800],
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    'Notes',
                    trade.notes,
                    icon: Icons.notes,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Performance Check',
                children: [
                  _buildCheckRow('Followed Strategy', trade.followedStrategy),
                  _buildDivider(),
                  _buildCheckRow(
                    'Proper Risk Management',
                    trade.properRiskManagement,
                  ),
                  _buildDivider(),
                  _buildCheckRow('Entry by Setup', trade.entryBySetup),
                  _buildDivider(),
                  _buildCheckRow('Disciplined SL/TP', trade.disciplinedSLTP),
                ],
              ),
              const SizedBox(height: 16),
              _buildImageSection('Before Trade', trade.beforeChartLink),
              const SizedBox(height: 16),
              _buildImageSection('After Trade', trade.afterChartLink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    IconData? icon,
    Color? color,
    int maxLines = 1,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          icon != null
              ? Icon(icon, color: color ?? Colors.blueGrey[600], size: 20)
              : null,
      title: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color ?? Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualDetail({
    required String leftLabel,
    required String leftValue,
    required String rightLabel,
    required String rightValue,
    Color? rightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftLabel,
              style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
            ),
            Text(
              leftValue,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightLabel,
              style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
            ),
            Text(
              rightValue,
              style: TextStyle(
                color: rightColor ?? Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckRow(String label, bool value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        value ? Icons.check_circle : Icons.cancel,
        color: value ? Colors.green[800] : Colors.red[800],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.blueGrey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildImageSection(String title, String imageUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: Colors.black12),
    );
  }
}
