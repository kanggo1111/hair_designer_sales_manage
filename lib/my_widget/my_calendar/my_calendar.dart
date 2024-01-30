import 'package:flutter/material.dart';
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
                        if (currentMonth == 1) {
                          currentYear--;
                          currentMonth = 12;
                        } else
                          currentMonth--;

                        now = DateTime(currentYear, currentMonth);
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
                      if (currentMonth == 12) {
                        currentYear++;
                        currentMonth = 1;
                      } else
                        currentMonth++;

                      now = DateTime(currentYear, currentMonth);
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
          CalendarCol(now),
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
          (index) =>
              CalendarRow(widget.now, index * 7 + 1 - (startingCell - 1))),
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
          (index) => CalendarCell(
              widget.now,
              widget.startDayOfWeek + index,
              index == 0
                  ? Colors.red
                  : index == 6
                      ? Colors.blue
                      : Colors.black)),
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
    final double cellWidth = MediaQuery.of(context).size.width * 5 / 37;
    final double cellHeight = MediaQuery.of(context).size.height / 9;
    final double cellBorderWidth = 0.5;

    final bool isDate = true;

    return Container(
        padding: EdgeInsets.all(2),
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: cellBorderWidth)),
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.dayOfCell > 0 &&
                      widget.dayOfCell <=
                          DateTime(widget.now.year, widget.now.month + 1, 0)
                              .day)
                    Text(widget.dayOfCell.toString(),
                        style: TextStyle(
                            color: widget.color)),
                  Text(' ',
                      style: TextStyle(
                          color: widget.color)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('3,100,200',
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 11)),
                    ],
                  ),
                  // 지출?
                  //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text('3,100,200',
                  //         style: TextStyle(
                  //             color: widget.color,
                  //             backgroundColor: Colors.grey,
                  //             fontSize: 11)),
                  //   ],
                  // )

                ],
              ),
            )),
          ],
        ));
  }
}
