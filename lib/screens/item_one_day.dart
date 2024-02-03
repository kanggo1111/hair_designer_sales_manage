import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/add_item_row.dart';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ItemOneDay extends StatefulWidget {
  const ItemOneDay(this.now, {super.key});

  final DateTime now;

  @override
  State<ItemOneDay> createState() => _ItemOneDayState();
}

class _ItemOneDayState extends State<ItemOneDay> {
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mainItemWidth = MediaQuery.of(context).size.width * 0.9;
    final mainItemHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      margin: EdgeInsets.all(10),
      width: mainItemWidth,
      // height: mainItemHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              DateFormat('y. MM. dd').format(widget.now),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              height: mainItemHeight * 0.6,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.blue.withOpacity(0.5),
                  child: Text(
                      '1\n\n\n\n\n\n2\n\n\n\n\n\n\n3\n\n\n\n\n\n\n4\n\n\n\n\n\n\n5'),
                ),
              ),
            ),
            AddItem(widget.now),
          ],
        ),
      ),
    );
  }
}
