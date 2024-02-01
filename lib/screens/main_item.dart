import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/add_item_row.dart';
import 'package:intl/intl.dart';

class MainItem extends StatelessWidget {
  const MainItem(this.now, {super.key});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final mainItemWidth = MediaQuery.of(context).size.width * 0.9;
    final mainItemHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      margin: EdgeInsets.all(10),
      width: mainItemWidth,
      height: mainItemHeight,
      child: Column(
        children: [
          Text(
            DateFormat('y. MM. dd').format(now),
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Container(
            height: mainItemHeight * 0.7,
            alignment: Alignment.center,
            color: Colors.blue.withOpacity(0.5),
            child: Text('space for Listview'),
          ),
          Expanded(
              child: Container(
                child: AddItemRow(now),
          )),
          Expanded(
              child: Container(
            color: Colors.red,
          )),
        ],
      ),
    );
  }
}