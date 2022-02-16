import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fx Rates',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: const FxRates(),
    );
  }
}

class FxRates extends StatefulWidget {
  const FxRates({Key? key}) : super(key: key);

  @override
  _FxRatesState createState() => _FxRatesState();
}

class _FxRatesState extends State<FxRates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fx Rates"),
      ),
    );
  }
}