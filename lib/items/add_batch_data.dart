import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<int> count = [0, 0, 0, 0];
int priceOfDay = 0;

class AddBatchData extends StatefulWidget {
  const AddBatchData(this.now, this.refreshDataList, {super.key});

  final DateTime now;
  final Function refreshDataList;

  @override
  State<AddBatchData> createState() => _AddBatchDataState();
}

class _AddBatchDataState extends State<AddBatchData> {
  bool tryValidation() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                children: [
                  ItemBatchCount('지명', 0),
                  ItemBatchCount('신규', 1),
                  ItemBatchCount('대체', 2),
                  ItemBatchCount('점판', 3),
                ],
              ),
            ),
            Column(
              children: [
                PriceTextField(),
                ElevatedButton(
                  onPressed: () {
                    if(tryValidation()){
                      // 데이터 저장
                      widget.refreshDataList();
                    }
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[100],
                      foregroundColor: Colors.black87,
                      side: BorderSide(width: 1)),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        SizedBox(
          height: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
        )
      ],
    );
  }
}

class ItemBatchCount extends StatefulWidget {
  const ItemBatchCount(this.typeName, this.typeIndex, {super.key});

  final String typeName;
  final int typeIndex;

  @override
  State<ItemBatchCount> createState() => _ItemBatchCountState();
}

class _ItemBatchCountState extends State<ItemBatchCount> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.value = TextEditingValue(text: '0');
  }

  void setCount(int cnt) {
    count[widget.typeIndex] = cnt;
    textEditingController.value =
        TextEditingValue(text: count[widget.typeIndex].toString());
  }

  void increaseCount(String str) {
    if (count[widget.typeIndex] < 99) {
      setCount(int.parse(str) + 1);
    }
  }

  void decreaseCount(String str) {
    if (count[widget.typeIndex] > 0) {
      setCount(int.parse(str) - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Text(
            widget.typeName,
            style: TextStyle(fontSize: 16),
          ),
          Container(
            child: IconButton(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                constraints: BoxConstraints(),
                color: Colors.black45,
                onPressed: () {
                  decreaseCount(textEditingController.value.text);
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  size: 20,
                )),
          ),
          Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                onTap: () {
                  textEditingController.value = TextEditingValue(text: '0');
                },
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('^[0-9]{1,2}\$'),
                      allow: true),
                ],
                decoration: InputDecoration(isDense: true),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  if (textEditingController.value.text == '')
                    textEditingController.value = TextEditingValue(text: '0');
                  setCount(int.parse(textEditingController.value.text));
                },
              )),
          IconButton(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              constraints: BoxConstraints(),
              color: Colors.black45,
              onPressed: () {
                increaseCount(textEditingController.value.text);
              },
              icon: Icon(Icons.add_circle_outline, size: 20)),
        ],
      ),
    );
  }
}

class PriceTextField extends StatefulWidget {
  const PriceTextField({super.key});

  @override
  State<PriceTextField> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  TextEditingController textEditingController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.value = TextEditingValue(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매출액',
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 40,
            width: 120,
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onTap: () {
                textEditingController.value = TextEditingValue(text: '0');
              },
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[0-9,]'), allow: true),
                CurrencyTextInputFormatter(
                    locale: 'ko-KR', decimalDigits: 0, symbol: '')
              ],
              decoration: InputDecoration(isDense: true),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                if (textEditingController.value.text.length < 4) {
                  textEditingController.value = TextEditingValue(
                      text: textEditingController.value.text + ',000');
                }
                textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: textEditingController.value.text.length - 4));
                priceOfDay = int.parse(
                    textEditingController.value.text.replaceAll(',', ''));
              },
            ),
          ),
        ],
      ),
    );
  }
}
