import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';

class UpdateTradeScreen extends StatefulWidget {
  final int tradeIndex;
  final String result;
  const UpdateTradeScreen({super.key, required this.tradeIndex, required this.result});

  @override
  State<UpdateTradeScreen> createState() => _UpdateTradeScreenState();
}

class _UpdateTradeScreenState extends State<UpdateTradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exitPriceController = TextEditingController();
  final _pnlController = TextEditingController();
  final _afterChartLinkController = TextEditingController();
  final _resultController = TextEditingController();

  @override
  void dispose() {
    _exitPriceController.dispose();
    _pnlController.dispose();
    _afterChartLinkController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _updateTrade() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TradeProvider>(context, listen: false);
      final oldTrade = provider.trades[widget.tradeIndex];

      final updatedTrade = TradeEntry(
        tradeTime: oldTrade.tradeTime,
        position: oldTrade.position,
        pair: oldTrade.pair,
        timeframe: oldTrade.timeframe,
        margin: oldTrade.margin,
        leverage: oldTrade.leverage,
        entryPrice: oldTrade.entryPrice,
        stopLoss: oldTrade.stopLoss,
        takeProfit: oldTrade.takeProfit,
        strategy: oldTrade.strategy,
        beforeChartLink: oldTrade.beforeChartLink,
        emotion: oldTrade.emotion,
        notes: oldTrade.notes,
        followedStrategy: oldTrade.followedStrategy,
        properRiskManagement: oldTrade.properRiskManagement,
        entryBySetup: oldTrade.entryBySetup,
        disciplinedSLTP: oldTrade.disciplinedSLTP,
        exitPrice: double.tryParse(_exitPriceController.text) ?? 0.0,
        pnl: double.tryParse(_pnlController.text) ?? 0.0,
        afterChartLink: _afterChartLinkController.text,
        result: widget.result,
        isDone: true,
      );

      provider.updateTrade(widget.tradeIndex, updatedTrade);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trade = Provider.of<TradeProvider>(context).trades[widget.tradeIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Trade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_exitPriceController, "Exit Price", isNumber: true),
              _buildTextField(_pnlController, "PnL (USD)", isNumber: true),
              _buildTextField(_afterChartLinkController, "After Chart Link"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTrade,
                child: const Text("Finish Trade"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
    );
  }
}