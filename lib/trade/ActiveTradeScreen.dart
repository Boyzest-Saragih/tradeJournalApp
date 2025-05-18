import 'package:flutter/material.dart';

class Activetradescreen extends StatefulWidget {
  const Activetradescreen({super.key});

  @override
  State<Activetradescreen> createState() => _ActivetradescreenState();
}

class _ActivetradescreenState extends State<Activetradescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Current Trade List Placeholder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to New Trade Form
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
