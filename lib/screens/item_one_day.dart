import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/add_item_row.dart';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';

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
    final listViewHeight = MediaQuery.of(context).size.height * 0.6;
    List<dynamic> listOfDay = myDB.getDataListOfDay(widget.now);

    print(MediaQuery.of(context).viewInsets.bottom);

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
          Expanded(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfDay.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          color: Colors.yellowAccent,
                          child: Text(index.toString()),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        Text(
                          listOfDay[index]
                              .toString()
                              .replaceAll('itemType', '\nitemType'),
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              AddItem(widget.now),
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
