import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/add_data_row.dart';
import 'package:hair_designer_sales_manage/items/data_list.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ItemOneDay extends StatefulWidget {
  const ItemOneDay(this.now, this.refreshCalendar, {super.key});

  final DateTime now;
  final Function refreshCalendar;

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
    widget.refreshCalendar();
    Navigator.of(context).pop();
    return true;
  }

  void refreshDataList() {
    setState(() {});
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
          Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.indigo, width: 1.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15,),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.all(5), child: Text('지명', style: TextStyle(fontSize: 16),)),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(NumberFormat('###,###,###,###')
                              .format(myDB.getDataTypeCountOfDay(widget.now, '지명')), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.all(5), child: Text('신규', style: TextStyle(fontSize: 16),)),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(NumberFormat('###,###,###,###')
                              .format(myDB.getDataTypeCountOfDay(widget.now, '신규')), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.all(5), child: Text('총객수', style: TextStyle(fontSize: 16),)),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(NumberFormat('###,###,###,###')
                              .format(myDB.getDataListCountOfDay(widget.now)), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.all(5), child: Text('일매출', style: TextStyle(fontSize: 16),)),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(NumberFormat('###,###,###,###')
                              .format(myDB.getSumPriceOfDay(widget.now)), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                const SizedBox(width: 15,),
              ],
            ),
          ),
          DataList(widget.now, refreshDataList),
          AddData(widget.now, refreshDataList),
        ],
      ),
    );
  }
}
