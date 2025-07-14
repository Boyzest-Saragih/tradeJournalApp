import 'package:flutter/material.dart';
import 'package:tradejournalapp/data/provider/trade_provider.dart';
import 'package:tradejournalapp/homeScreen/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:tradejournalapp/trade/ActiveTradeScreen.dart';
import 'package:tradejournalapp/trade/UpdateTradeScreen.dart';
import 'package:tradejournalapp/trade/addTradeForm.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_){
        final provider = TradeProvider();
        provider.loadTrades(); // ⬅️ Penting: Load saat startup
        return provider;
      })
    ],
    child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomeScreen(),
    );
  }
}

