import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/screens/main_screen.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    myDB = MyDB();
    myDB.readMyDB();

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: false),
      title: 'Hair designer sales manager',
      home: MainScreen(),
    );
  }
}
