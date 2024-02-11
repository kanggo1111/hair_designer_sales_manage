import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

String _itemType = '';
late Function _globalSetState;
late Function _globalTryValidation;
late TextEditingController _controller;
late FocusNode _priceTextFieldFocusNode;
bool _isAddedBuSubmitButton = true;

class AddData extends StatefulWidget {
  AddData(this.now, this.refreshDataList, {super.key});

  final DateTime now;
  final Function refreshDataList;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  int _itemPrice = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _priceTextFieldFocusNode = FocusNode();
    _globalSetState = setItem;
    _globalTryValidation = _tryPriceValidation;
    setItem('');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceTextFieldFocusNode.dispose();
  }

  void setItem(String itemType){
    setState(() {
      _itemType = itemType;
    });
  }

  bool _tryPriceValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 0,
          thickness: 5,
          color: Colors.indigo,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                addDataTypeBox(_itemType),
                IconButton(
                  onPressed: () {
                    setItem('');
                  },
                  icon: Icon(
                    Icons.highlight_remove_sharp,
                    color: (_itemType.length == 0 ||
                            _itemType.length == 0)
                        ? Colors.grey
                        : Colors.red[700],
                  ),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                )
              ],
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
                      focusNode: _priceTextFieldFocusNode,
                      controller: _controller,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(height: 0), hintText: '0'),
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp('[0-9,]'),
                            allow: true),
                        CurrencyTextInputFormatter(
                            locale: 'ko-KR', decimalDigits: 0, symbol: '')
                      ],
                      validator: (value) {
                        if (value!.isEmpty ||
                            _itemType.length == 0) {
                          return '';
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _controller.value = TextEditingValue(text: '');
                      },
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (_controller.value.text.length < 4) {
                          _controller.value = TextEditingValue(
                              text: _controller.value.text + ',000');
                        }
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(
                                offset: _controller.value.text.length - 4));
                      },
                      onSaved: (value) async {
                        _itemPrice = int.parse(value!.replaceAll(',', ''));

                        Map data = {};
                        data['date'] = DateFormat('y-MM-dd').format(widget.now);
                        data['itemType'] = _itemType;
                        data['itemPrice'] = _itemPrice;

                        await myDB.writeMyDB(data);
                        //myDB.resetMyDB();

                        widget.refreshDataList();
                      },
                      onFieldSubmitted: (value) {
                        _isAddedBuSubmitButton = true;
                        _tryPriceValidation();
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            ItemButton('지명', Colors.black87),
            ItemButton('신규', Colors.black87),
            ItemButton('대체', Colors.black87),
            ItemButton('점판', Colors.black87),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }
}

class addDataTypeBox extends StatefulWidget {
  addDataTypeBox(this.text, {super.key});

  String text;

  @override
  State<addDataTypeBox> createState() => _addDataTypeBoxState();
}

class _addDataTypeBoxState extends State<addDataTypeBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.text.length > 0 ? Colors.blue[300] : Colors.grey),
      alignment: Alignment.center,
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  const ItemButton(
      this.itemType, this.itemTypeColor,
      {super.key});

  final String itemType;
  final Color itemTypeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _globalSetState(itemType);
        if(_priceTextFieldFocusNode.hasFocus == false){
          _controller.value = TextEditingValue(text: '');
        }
        else {
          if(_isAddedBuSubmitButton == false){
            _globalTryValidation();
          }
        }
        _isAddedBuSubmitButton = false;
        _controller.value = TextEditingValue(text: '');
        FocusScope.of(context).requestFocus(_priceTextFieldFocusNode);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black87)),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: Text(
          itemType,
          style: TextStyle(
            color: itemTypeColor,
          ),
        ),
      ),
    );
  }
}