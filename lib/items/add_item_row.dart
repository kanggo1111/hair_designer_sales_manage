import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _tryPriceValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownMenu<String>(
          width: 100,
          initialSelection: temp_itemNameList.first,
          onSelected: (String? value) {
            setState(() {
              itemName = value!;
              itemPrice =
              temp_itemPriceList[temp_itemNameList.indexOf(itemName)];
              _controller.value = TextEditingValue(text: NumberFormat('###,###,###,###').format(itemPrice));
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
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(errorStyle: TextStyle(height: 0)),
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[0-9,]'), allow: true),
                    CurrencyTextInputFormatter(
                        locale: 'ko-KR', decimalDigits: 0, symbol: '')
                  ],
                  validator: (value){
                    if (value!.isEmpty) {
                      return '';
                    } else {
                      return null;
                    }
                  },
                  onTap: () {
                    _controller.value = TextEditingValue(text: '');
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    itemPrice = int.parse(value!.replaceAll(',', ''));
                    print(itemPrice);
                  },
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    onPressed: () {
                      if(_tryPriceValidation()){
                        print(DateFormat('y-MM-dd').format(widget.now) +
                            ' ' +
                            itemName +
                            ' ' +
                            itemPrice.toString());
                      }
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
