import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int currentMonth = 1; // 1 ~ 12
  int currentYear = 2024; // 1 ~ 12
  int startingCell = 1;
  var now;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = new DateTime.now();
    getCurrentMonth();
  }

  void getCurrentMonth() {
    currentMonth = int.parse(DateFormat('MM').format(now));
    currentYear = int.parse(DateFormat('y').format(now));
  }

  void setNextMonth() {
    if (currentMonth == 12) {
      currentYear++;
      currentMonth = 1;
    } else {
      currentMonth++;
    }

    now = DateTime(currentYear, currentMonth);
  }

  void setPrevMonth() {
    if (currentMonth == 1) {
      currentYear--;
      currentMonth = 12;
    } else {
      currentMonth--;
    }

    now = DateTime(currentYear, currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    int typeCnt1 = myDB.getDataTypeCountOfMonth(now, '지명');
    int typeCnt2 = myDB.getDataTypeCountOfMonth(now, '신규');
    int typeCnt3 = myDB.getDataTypeCountOfMonth(now, '대체');
    int typeCnt4 = myDB.getDataTypeCountOfMonth(now, '점판');
    int totalCnt = typeCnt1 + typeCnt2 + typeCnt3 + typeCnt4;

    int typeSumPrice1 = myDB.getSumPriceByTypeOfMonth(now, '지명');
    int typeSumPrice2 = myDB.getSumPriceByTypeOfMonth(now, '신규');
    int typeSumPrice3 = myDB.getSumPriceByTypeOfMonth(now, '대체');
    int typeSumPrice4 = myDB.getSumPriceByTypeOfMonth(now, '점판');
    int totalPrice =
        typeSumPrice1 + typeSumPrice2 + typeSumPrice3 + typeSumPrice4;

    String textTypeSumPrice1 =
        NumberFormat('###,###,###,###').format(typeSumPrice1);
    String textTypeSumPrice2 =
        NumberFormat('###,###,###,###').format(typeSumPrice2);
    String textTypeSumPrice3 =
        NumberFormat('###,###,###,###').format(typeSumPrice3);
    String textTypeSumPrice4 =
        NumberFormat('###,###,###,###').format(typeSumPrice4);
    String textTotalPrice = NumberFormat('###,###,###,###').format(totalPrice);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.indigo),
                          left: BorderSide(color: Colors.indigo),
                          right: BorderSide(color: Colors.indigo),
                          bottom: BorderSide(color: Colors.indigo),
                        ),

                      ),
                      child: Text('월별'))),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.indigo),
                            left: BorderSide(color: Colors.indigo),
                            right: BorderSide(color: Colors.indigo),
                            bottom: BorderSide(color: Colors.indigo)),
                      ),
                      child: Text('기간별'))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      setPrevMonth();
                    });
                  },
                  child: Icon(
                    Icons.arrow_left,
                    size: 40,
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(
                currentYear.toString() +
                    '. ' +
                    currentMonth.toString().padLeft(2, "0"),
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    setNextMonth();
                  });
                },
                child: Icon(
                  Icons.arrow_right,
                  size: 40,
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!, width: 0.5)),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      child: MonthlyStatisticsTableRow(
                          Text(''), Text('건수'), Text('금액')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.indigo.withOpacity(0.08),
                      child: MonthlyStatisticsTableRow(
                        Text('지명'),
                        Text(typeCnt1.toString()),
                        Text(textTypeSumPrice1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      child: MonthlyStatisticsTableRow(
                        Text('신규'),
                        Text(typeCnt2.toString()),
                        Text(textTypeSumPrice2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.indigo.withOpacity(0.08),
                      child: MonthlyStatisticsTableRow(
                        Text('대체'),
                        Text(typeCnt3.toString()),
                        Text(textTypeSumPrice3),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      child: MonthlyStatisticsTableRow(
                        Text('점판'),
                        Text(typeCnt4.toString()),
                        Text(textTypeSumPrice4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.indigo.withOpacity(0.2),
                      child: MonthlyStatisticsTableRow(
                          Text('계'),
                          Text(totalCnt.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(textTotalPrice,
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget MonthlyStatisticsTableRow(
    Widget childText1, Widget childText2, Widget childText3) {
  return Row(
    children: [
      MonthlyStatisticsTableCell(childText1),
      MonthlyStatisticsTableCell(childText2),
      MonthlyStatisticsTableCell(childText3),
    ],
  );
}

Widget MonthlyStatisticsTableCell(Widget childText) {
  Color borderColor = Colors.grey[400]!;
  return Expanded(
      child: Container(
    alignment: Alignment.center,
    decoration:
        BoxDecoration(border: Border.all(color: borderColor, width: 0.5)),
    child: childText,
  ));
}
