import 'package:flutter/material.dart';
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
    return Container(
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
    );
  }
}
