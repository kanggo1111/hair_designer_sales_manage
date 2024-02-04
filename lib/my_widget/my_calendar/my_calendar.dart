import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/screens/item_one_day.dart';
import 'package:intl/intl.dart';

Map<String, int> weekday = {
  "SUN": 1,
  "MON": 2,
  "TUE": 3,
  "WED": 4,
  "THU": 5,
  "FRI": 6,
  "SAT": 7,
};

const double cellBorderWidth = 0.1;

class MyCalendar extends StatefulWidget {
  MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
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

  void showMainItemAlert(BuildContext context, DateTime now) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetAnimationCurve: Curves.easeIn,
            insetAnimationDuration: Duration(milliseconds: 100),
            backgroundColor: Colors.white,
            child: ItemOneDay(now),
          );
        });
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 37, 0,
          MediaQuery.of(context).size.width / 37, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
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
                      size: 30,
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
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            child: CalendarCol(now),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: cellBorderWidth)),
          )),
          Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      IconButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            // widget._navigatorKey.currentState?.pushNamed('/B');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemOneDay(now)));
                            //showMainItemAlert(context, DateTime.now());
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.indigo,
                            size: 60,
                          ))
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class CalendarCol extends StatefulWidget {
  CalendarCol(this.now, {super.key});

  final DateTime now;

  @override
  State<CalendarCol> createState() => _CalendarColState();
}

class _CalendarColState extends State<CalendarCol> {
  @override
  Widget build(BuildContext context) {
    int startingCell = weekday[DateFormat('E')
        .format(DateTime(widget.now.year, widget.now.month, 1))
        .toUpperCase()]!;
    return Column(
      children: List.generate(
          5 * 7 + 1 - (startingCell - 1) <=
                  DateTime(widget.now.year, widget.now.month + 1, 0).day
              ? 6
              : 5,
          (index) => Expanded(
              child: Container(
                  child: CalendarRow(
                      widget.now, index * 7 + 1 - (startingCell - 1))))),
    );
  }
}

class CalendarRow extends StatefulWidget {
  const CalendarRow(this.now, this.startDayOfWeek, {super.key});

  final DateTime now;
  final int startDayOfWeek;

  @override
  State<CalendarRow> createState() => _CalendarRowState();
}

class _CalendarRowState extends State<CalendarRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          7,
          (index) => Expanded(
                child: Container(
                  child: CalendarCell(
                      widget.now,
                      widget.startDayOfWeek + index,
                      index == 0
                          ? Colors.red
                          : index == 6
                              ? Colors.blue
                              : Colors.black),
                ),
              )),
    );
  }
}

class CalendarCell extends StatefulWidget {
  const CalendarCell(this.now, this.dayOfCell, this.color, {super.key});

  final DateTime now;
  final int dayOfCell;
  final Color color;

  @override
  State<CalendarCell> createState() => _CalendarCellState();
}

class _CalendarCellState extends State<CalendarCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemOneDay(DateTime(
                widget.now.year, widget.now.month, widget.dayOfCell))));
      },
      child: Stack(
          children: getCellContent(widget.dayOfCell, widget.now.year,
              widget.now.month, widget.color)),
    );
  }
}

List<Widget> getCellContent(int dayOfCell, int year, int month, Color color) {
  int lastDayOfCurrentMonth = DateTime(year, month + 1, 0).day;
  List<Widget> textList = [];
  List<Widget> returnList = [];
  bool isNeedShadow = true;
  Color incomeTextColor = Colors.blue[300]!;

  Container notThisMonthShadowContainer =
      Container(color: Colors.grey.withOpacity(0.15));
  Container todayShadowContainer = Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: cellBorderWidth*15)),
  );

  if (dayOfCell > 0 && dayOfCell <= lastDayOfCurrentMonth) {
    textList.add(Text(dayOfCell.toString(), style: TextStyle(color: color)));
    isNeedShadow = false;
  } else if (dayOfCell <= 0) {
    int lastDayOfPrevMonth = DateTime(year, month, 0).day;
    int prevMonth = month != 1 ? month - 1 : 12;
    textList.add(Text(
        prevMonth.toString() +
            '. ' +
            (dayOfCell + lastDayOfPrevMonth).toString(),
        style: TextStyle(color: color.withOpacity(0.5))));
    incomeTextColor = incomeTextColor.withOpacity(0.5);
  } else if (dayOfCell > lastDayOfCurrentMonth) {
    int nextMonth = month != 12 ? month + 1 : 1;
    textList.add(Text(
        nextMonth.toString() +
            '. ' +
            (dayOfCell - lastDayOfCurrentMonth).toString(),
        style: TextStyle(color: color.withOpacity(0.5))));
    incomeTextColor = incomeTextColor.withOpacity(0.5);
  } else {
    textList.add(const Text(' '));
  }

  textList.add(const SizedBox(
    height: 10,
  ));
  textList.add(Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text('3,100,200', style: TextStyle(color: incomeTextColor, fontSize: 11)),
    ],
  ));

  return [
    Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: cellBorderWidth)),
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: textList,
              ),
            )),
          ],
        )),
    if (isNeedShadow) notThisMonthShadowContainer,
    if (dayOfCell == int.parse(DateFormat('dd').format(DateTime.now())))
      todayShadowContainer,
  ];
}
