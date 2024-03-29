import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const MY_DATABASE_FILE_PATH = 'my_database.txt';

late MyDB myDB;
List<dynamic> currentData = List.empty(growable: true);
bool readMyDBCalled = false;
int sortType = dataSortType.indexOf('기록 시간순');

// List<String> temp_itemNameList = ['커트', '펌', '염색', '오예오예오예오예오예', '커트', '펌', '염색', '커트', '펌', '염색', '커트', '펌', '염색', '커트', '펌', '염색'];
// List<int> temp_itemPriceList = [20000, 56000, 48000, 1000000, 20000, 56000, 48000, 20000, 56000, 48000, 20000, 56000, 48000, 20000, 56000, 48000];
List<String> itemTypeList = ['지명', '신규', '대체', '점판'];
List<String> dataSortType = [
  '금액 내림차순',
  '금액 오름차순',
  '기록 시간순',
  '분류 내림차순',
  '분류 오름차순'
];
List<Function> dataSortFunc = [
  descendingByPrice,
  ascendingByPrice,
  ascendingByAddTime,
  descendingByType,
  ascendingByType
];
//List<String> itemTypeList2 = ['커트', '화학'];

int descendingByPrice(var a, var b) {
  return a['itemPrice'] > b['itemPrice'] ? -1 : 1;
}

int ascendingByPrice(var a, var b) {
  return a['itemPrice'] < b['itemPrice'] ? -1 : 1;
}

int ascendingByAddTime(var a, var b) {
  return a['id'].compareTo(b['id']);
}

int descendingByType(var a, var b) {
  return b['itemType'].compareTo(a['itemType']);
}

int ascendingByType(var a, var b) {
  return a['itemType'].compareTo(b['itemType']);
}

class MyDB {
  MyDB();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$MY_DATABASE_FILE_PATH');
  }

  Future<List> readMyDB() async {
    try {
      final file = await _localFile;

      if (readMyDBCalled) return currentData;
      // Read the file
      final contents = await file.readAsString();

      List readData = jsonDecode(contents);

      if (readData.length != currentData.length) {
        // TODO: fix not to overlap on hot reload
        currentData.addAll(readData);
      }
      print('R1 ' + currentData.length.toString());
      currentData.forEach((element) {
        print('R2 ' + element.toString());
      });

      readMyDBCalled = true;
      return currentData;
    } catch (e) {
      // If encountering an error, return 0
      print('readMyDB catch');
      return [];
    }
  }

  Future<File> writeMyDB(newData) async {
    final file = await _localFile;

    // Write the file

    String newDataId = DateFormat('yMMddHHmmssS').format(DateTime.now());
    newData['id'] = newDataId;

    //print('W1 ' + currentData.toString());
    print('W2 ' + newData.toString());

    currentData.add(newData);
    // print('W3 '+ currentData.toString());

    String modifiedDataStr = jsonEncode(currentData);
    // print('W4 '+ modifiedDataStr);
    return file.writeAsString(modifiedDataStr);

    // return file.writeAsString('', mode: FileMode.append);
  }

  Future<File> deleteMyDB(deleteData) async {
    final file = await _localFile;

    // Write the file

    //print('D1 ' + currentData.toString());
    print('D2 ' + deleteData.toString());

    //currentData.add(newData);
    currentData.removeWhere((element) => element['id'] == deleteData['id']);

    //print('W3 '+ currentData.toString());

    String modifiedDataStr = jsonEncode(currentData);
    return file.writeAsString(modifiedDataStr);

    // return file.writeAsString('', mode: FileMode.append);
  }

  Future<File> resetMyDB() async {
    final file = await _localFile;

    // file.writeAsString('');
    // String testDataSet =
    //     '[{"date": "2024-02-03", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "커트", "itemPrice": 20000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "커트", "itemPrice": 20000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}]';
    // return file.writeAsString(testDataSet);

    // Write the file
    return file.writeAsString('[]');
  }

  List<dynamic> getDataListOfDay(DateTime now) {
    List<dynamic> selectedList = [];

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        selectedList.add(element);
      }
    });

    selectedList.sort((a, b) => dataSortFunc[sortType](a, b));

    // print(selectedList.length);
    // selectedList.forEach((element) {print(selectedList.toString());});

    return selectedList;
  }

  int getDataListCountOfDay(DateTime now) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        sum++;
      }
    });

    return sum;
  }

  int getSumPriceOfDay(DateTime now) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        sum += element['itemPrice'] as int;
      }
    });

    return sum;
  }

  int getDataTypeCountOfDay(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now) &&
          element['itemType'] == type) {
        sum++;
      }
    });

    return sum;
  }

  int getDataTypeCountOfMonth(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'].startsWith(DateFormat('y-MM').format(now)) &&
          element['itemType'] == type) {
        sum++;
      }
    });

    return sum;
  }

  int getSumPriceByTypeOfMonth(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'].startsWith(DateFormat('y-MM').format(now)) &&
          element['itemType'] == type) {
        sum += element['itemPrice'] as int;
      }
    });

    return sum;
  }

  void setDataSortType(int selectedSortType) {
    sortType = selectedSortType;
  }
}
