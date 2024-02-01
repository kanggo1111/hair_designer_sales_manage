import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> temp_itemNameList = ['커트', '펌', '염색', '오예'];
List<int> temp_itemPriceList = [20000, 56000, 48000, 1000000];

class AddItemRow extends StatefulWidget {
  AddItemRow(this.now, {super.key});

  final DateTime now;

  @override
  State<AddItemRow> createState() => _AddItemRowState();
}

class _AddItemRowState extends State<AddItemRow> {
  String itemName = temp_itemNameList.first;
  int itemPrice = temp_itemPriceList.first;
  String itemPriceStr = temp_itemNameList.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownMenu<String>(
          width: 100,
          initialSelection: temp_itemNameList.first,
          onSelected: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              itemName = value!;
              itemPrice =
                  temp_itemPriceList[temp_itemNameList.indexOf(itemName)];
            });
          },
          dropdownMenuEntries:
              temp_itemNameList.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              alignment: AlignmentDirectional.centerEnd,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                NumberFormat('###,###,###,###').format(itemPrice),
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    onPressed: () {
                      print(DateFormat('y-MM-dd').format(widget.now) +
                          ' ' +
                          itemName +
                          ' ' +
                          itemPrice.toString());

                      print(NumberFormat('###,###,###,###').format(itemPrice));
                      print(int.parse(NumberFormat('###,###,###,###')
                          .format(itemPrice)
                          .replaceAll(',', '')));
                    },
                    child: Text(
                      '추가',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    )))
          ],
        )
      ],
    );
  }
}
