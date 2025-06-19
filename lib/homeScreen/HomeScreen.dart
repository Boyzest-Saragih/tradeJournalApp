import 'package:flutter/material.dart';
import 'package:tradejournalapp/dashboard/DashboardScreen.dart';
import 'package:tradejournalapp/trade/ActiveTradeScreen.dart';
import 'package:tradejournalapp/trade/HistoryScreen.dart';

void main() {
  runApp(TradingJournalApp());
}

class TradingJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading Journal',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Dashboardscreen(),
    Activetradescreen(),
    Historyscreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan, Wait, Execute.'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://plus.unsplash.com/premium_photo-1664476845274-27c2dabdd7f0?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ),
                  fit: BoxFit.cover
                ),
              ),
              child: Text(
                'Loss is a Lesson',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Trade Aktif'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History Trade'),
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
