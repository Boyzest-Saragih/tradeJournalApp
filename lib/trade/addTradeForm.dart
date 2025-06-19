import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';

class TradeFormScreen extends StatefulWidget {
  const TradeFormScreen({super.key});

  @override
  State<TradeFormScreen> createState() => _TradeFormScreenState();
}

class _TradeFormScreenState extends State<TradeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late var position = "";
  final _marginController = TextEditingController();
  final _leverageController = TextEditingController();
  final _entryPriceController = TextEditingController();
  final _beforeChartLinkController = TextEditingController();
  final _pairController = TextEditingController();
  final _timeframeController = TextEditingController();
  final _strategyController = TextEditingController();
  final _emotionController = TextEditingController();
  final _notesController = TextEditingController();

  bool _followedStrategy = false;
  bool _properRiskManagement = false;
  bool _entryBySetup = false;
  bool _disciplinedSLTP = false;

  @override
  void dispose() {
    _marginController.dispose();
    _leverageController.dispose();
    _entryPriceController.dispose();
    _beforeChartLinkController.dispose();
    _pairController.dispose();
    _timeframeController.dispose();
    _strategyController.dispose();
    _emotionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTrade() {
    if (_formKey.currentState!.validate()) {
      final newTrade = TradeEntry(
        tradeTime: DateTime.now(),
        position: position,
        margin: double.tryParse(_marginController.text) ?? 0.0,
        leverage: int.tryParse(_leverageController.text) ?? 1,
        entryPrice: double.tryParse(_entryPriceController.text) ?? 0.0,
        exitPrice: 0.0,
        pnl: 0.0,
        beforeChartLink: _beforeChartLinkController.text,
        afterChartLink: "",
        pair: _pairController.text,
        timeframe: _timeframeController.text,
        strategy: _strategyController.text,
        result: "",
        emotion: _emotionController.text,
        notes: _notesController.text,
        followedStrategy: _followedStrategy,
        properRiskManagement: _properRiskManagement,
        entryBySetup: _entryBySetup,
        disciplinedSLTP: _disciplinedSLTP,
        isDone: false,
      );

      Provider.of<TradeProvider>(context, listen: false).addTrade(newTrade);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Trade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: position.isNotEmpty ? position : null,
                decoration: InputDecoration(
                  labelText: "Position",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: "Long", child: Text("Long")),
                  DropdownMenuItem(value: "Short", child: Text("Short")),
                ],
                onChanged: (v) => setState(() => position = v!),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please select a position"
                            : null,
              ),

              // Text Inputs
              _buildTextField(
                _marginController,
                "Margin (USD)",
                isNumber: true,
              ),
              _buildTextField(_leverageController, "Leverage", isNumber: true),
              _buildTextField(
                _entryPriceController,
                "Entry Price",
                isNumber: true,
              ),
              _buildTextField(_beforeChartLinkController, "Before Chart Link"),
              _buildTextField(_pairController, "Pair (e.g. BTC/USDT)"),
              _buildTextField(_timeframeController, "Timeframe (e.g. 15m)"),
              _buildTextField(_strategyController, "Strategy"),
              _buildTextField(_emotionController, "Emotion"),
              _buildTextField(_notesController, "Notes", maxLines: 3),

              // Checkbox Inputs
              CheckboxListTile(
                title: Text("Followed Strategy"),
                value: _followedStrategy,
                onChanged:
                    (val) => setState(() => _followedStrategy = val ?? false),
              ),
              CheckboxListTile(
                title: Text("Proper Risk Management"),
                value: _properRiskManagement,
                onChanged:
                    (val) =>
                        setState(() => _properRiskManagement = val ?? false),
              ),
              CheckboxListTile(
                title: Text("Entry by Setup"),
                value: _entryBySetup,
                onChanged:
                    (val) => setState(() => _entryBySetup = val ?? false),
              ),
              CheckboxListTile(
                title: Text("Disciplined SL/TP"),
                value: _disciplinedSLTP,
                onChanged:
                    (val) => setState(() => _disciplinedSLTP = val ?? false),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTrade,
                child: const Text("Save Trade"),
              ),
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'This field is required'
                    : null,
      ),
    );
  }
}
