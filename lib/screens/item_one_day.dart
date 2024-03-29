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
  static String dropdownValue = '기록 시간순';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  DateFormat('y. MM. dd').format(widget.now),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Row(
                children: [
                  Text('정렬'),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          alignment: Alignment.center,
                          isDense: true,
                          underline: null,
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: Colors.indigo[100],
                          value: dropdownValue,
                          items: dataSortType.map((String sortType) {
                            return DropdownMenuItem<String>(
                              child: Text(sortType),
                              value: sortType,
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) {
                              value = '기록 시간순';
                            }
                            setState(() {
                              dropdownValue = value!;
                            });
                            myDB.setDataSortType(dataSortType.indexOf(value!));
                            refreshDataList();
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.indigo, width: 1.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '지명',
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              NumberFormat('###,###,###,###').format(
                                  myDB.getDataTypeCountOfDay(widget.now, '지명')),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '신규',
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              NumberFormat('###,###,###,###').format(
                                  myDB.getDataTypeCountOfDay(widget.now, '신규')),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '총객수',
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              NumberFormat('###,###,###,###').format(
                                  myDB.getDataListCountOfDay(widget.now)),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '일매출',
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                              NumberFormat('###,###,###,###')
                                  .format(myDB.getSumPriceOfDay(widget.now)),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
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
