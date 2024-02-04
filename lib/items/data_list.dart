import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: listOfDay.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.indigo[50],
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth*0.05,
                        alignment: AlignmentDirectional.centerEnd,
                        margin: EdgeInsets.only(left: 10),
                        child: Text((index+1).toString(), style: TextStyle(fontSize: 15), maxLines: 1),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: screenWidth*0.11,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(listOfDay[index]['itemType'], style: TextStyle(fontSize: 15), maxLines: 1),
                      ),
                      Container(
                        width: screenWidth*0.3,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(listOfDay[index]['itemName'], style: TextStyle(fontSize: 15), maxLines: 1),
                      ),
                      Container(
                        width: screenWidth*0.17,
                        alignment: AlignmentDirectional.centerEnd,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(NumberFormat('###,###,###,###').format(listOfDay[index]['itemPrice']), style: TextStyle(fontSize: 15), maxLines: 1),
                      ),
                    ],
                  ),
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
