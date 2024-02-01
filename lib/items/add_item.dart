import 'package:flutter/material.dart';

List<String> temp_itemNameList = ['커트', '펌', '염색'];
List<int> temp_itemPriceList = [20000, 56000, 48000];

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String dropdownValue = temp_itemNameList.first;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ItemNameDropdownMenu(),
        Container(
          child: Text('d'),
        )
      ],
    );
  }
}

class ItemNameDropdownMenu extends StatefulWidget {
  ItemNameDropdownMenu({super.key});

  @override
  State<ItemNameDropdownMenu> createState() => _ItemNameDropdownMenuState();
}

class _ItemNameDropdownMenuState extends State<ItemNameDropdownMenu> {
  String dropdownValue = temp_itemNameList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: 100,
      initialSelection: temp_itemNameList.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: temp_itemNameList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}