import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/add_data_row.dart';
import 'package:hair_designer_sales_manage/items/data_list.dart';
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

  void refreshDataList(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final listViewHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              DateFormat('y. MM. dd').format(widget.now),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          DataList(widget.now, refreshDataList),
          Column(
            children: [
              AddData(widget.now, refreshDataList),
              if (MediaQuery.of(context).viewInsets.bottom > 0)
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
            ],
          ),
        ],
      ),
    );
  }
}
