import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/my_widget/my_calendar/my_calendar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/12,
        title: Text('Main Screen'),
        elevation: 0,
      ),
      body: Center(
        child: MyCalendar(),
      ),
    );
  }
}
