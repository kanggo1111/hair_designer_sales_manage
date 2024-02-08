import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'item_list.dart';

class AddData extends StatefulWidget {
  AddData(this.now, this.refreshDataList, {super.key});

  final DateTime now;
  final Function refreshDataList;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  String _itemName = temp_itemNameList.first;
  int _itemPrice = temp_itemPriceList.first;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _itemType = itemTypeList[0];
  FocusNode _priceTextFieldFocusNode = FocusNode();

  bool _tryPriceValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceTextFieldFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 5),
          alignment: AlignmentDirectional.centerEnd,
          width: 100,
          child: Form(
            key: _formKey,
            child: TextFormField(
              focusNode: _priceTextFieldFocusNode,
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
              onChanged: (value){
                if(_controller.value.text.length < 4){
                  _controller.value = TextEditingValue(text: _controller.value.text + ',000');
                }
                _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.value.text.length - 4));
              },
              onSaved: (value) {
                _itemPrice = int.parse(value!.replaceAll(',', ''));
              },
              onFieldSubmitted: (value){
                _tryPriceValidation();
              },
            ),
          ),
        ),
        Row(
            children: List.generate(
              itemTypeList.length,
                  (index) => GestureDetector(
                    onTap: (){
                      FocusScope.of(context).requestFocus(_priceTextFieldFocusNode);
                      _controller.value = TextEditingValue(text: '');
                      if(_controller.value.text.length != 0){ // 입력한 상태에서 추가 입력하려는 경우
                        _tryPriceValidation();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    margin: EdgeInsets.all(10),
                                    color: Colors.greenAccent,
                                    child: Text(itemTypeList[index]),
                                  ),
                  ),
            )),
        if (MediaQuery.of(context).viewInsets.bottom > 0)
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
      ],
    );
  }
}

/*
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

                            widget.refreshDataList();
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

 */