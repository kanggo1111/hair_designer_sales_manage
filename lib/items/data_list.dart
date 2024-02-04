import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';

class DataList extends StatefulWidget {
  const DataList(this.now, this.refreshDataList, {super.key});

  final DateTime now;
  final Function refreshDataList;

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
//
  @override
  Widget build(BuildContext context) {
    List<dynamic> listOfDay = myDB.getDataListOfDay(widget.now);

    return Expanded(
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
                  Text(listOfDay[index]['id'] + ' ',
                      style: TextStyle(fontSize: 10)),
                  Text(listOfDay[index]['itemType'].padLeft(7) + ' ',
                      style: TextStyle(fontSize: 10)),
                  Text(listOfDay[index]['itemName'].padLeft(7) + ' ',
                      style: TextStyle(fontSize: 10)),
                  Text(
                      listOfDay[index]['itemPrice'].toString().padLeft(7) + ' ',
                      style: TextStyle(fontSize: 10)),
                  IconButton(
                      onPressed: () {
                        myDB.deleteMyDB(listOfDay[index]);
                        widget.refreshDataList();
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
