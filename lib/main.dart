import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filio Test',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const platform = MethodChannel('com.example.app/db');

  int value = -1;

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async{
    await _dbHelper.insertValue();
    getValue();
  }

  Future<void> getValue() async {
    await Future.delayed(const Duration(milliseconds: 10));
    var val = await _dbHelper.getValue();
    setState(() {
      value = val;
    });
  }

  Future<void> incrementValue() async {
    await platform.invokeMethod("incrementValue");
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Value is :  $value'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: incrementValue,
          child: const Text('Increment Value'),
        ),
      ),
    );
  }
}
