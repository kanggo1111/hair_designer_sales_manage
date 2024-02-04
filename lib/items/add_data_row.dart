import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'item_list.dart';

class AddData extends StatefulWidget {
  AddData(this.now, {super.key});

  final DateTime now;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  String _itemName = temp_itemNameList.first;
  int _itemPrice = temp_itemPriceList.first;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _itemType = itemTypeList[0];

  bool _tryPriceValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: List.generate(
              itemTypeList.length,
                  (index) => Container(
                margin: EdgeInsets.all(5),
                //color: Colors.redAccent,
                width: 80,
                child: RadioListTile(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Text(itemTypeList[index]),
                  value: itemTypeList[index],
                  groupValue: _itemType,
                  onChanged: (value) {
                    setState(() {
                      _itemType = value!;
                    });
                  },
                ),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: DropdownMenu<String>(
                width: 120,
                initialSelection: temp_itemNameList.first,
                onSelected: (String? value) {
                  setState(() {
                    _itemName = value!;
                    _itemPrice =
                    temp_itemPriceList[temp_itemNameList.indexOf(_itemName)];
                    _controller.value = TextEditingValue(text: NumberFormat('###,###,###,###').format(_itemPrice));
                  });
                },
                dropdownMenuEntries:
                    temp_itemNameList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: AlignmentDirectional.centerEnd,
                  width: 100,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _controller,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(errorStyle: TextStyle(height: 0), hintText: '0'),
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
                        _itemPrice = int.parse(value!.replaceAll(',', ''));
                      },
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                        onPressed: () async{
                          if(_tryPriceValidation()){
                            Map data = {};
                            data['date'] = DateFormat('y-MM-dd').format(widget.now);
                            data['itemType'] = _itemType;
                            data['itemName'] = _itemName;
                            data['itemPrice'] = _itemPrice;

                            await myDB.writeMyDB(data);
                            //myDB.resetMyDB();
                          }
                        },
                        child: Text(
                          '추가',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )))
              ],
            )
          ],
        ),
      ],
    );
  }
}
