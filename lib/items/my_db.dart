import 'dart:io';
import 'dart:convert';
import 'package:hair_designer_sales_manage/items/config.dart';
import 'package:hair_designer_sales_manage/items/data.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const myDBFilePath = 'my_database.txt';
const myConfigFilePath = 'my_config.txt';

late MyDB myDB;
bool readMyDBCalled = false;
List<dynamic> currentData = List.empty(growable: true);

late MyConfig myConfig;
bool readMyConfigCalled = false;

int sortType = dataSortType.indexOf('기록 시간순');

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

int descendingByPrice(var a, var b) {
  return a['price'] > b['price'] ? -1 : 1;
}

int ascendingByPrice(var a, var b) {
  return a['price'] < b['price'] ? -1 : 1;
}

int ascendingByAddTime(var a, var b) {
  return a['id'].compareTo(b['id']);
}

int descendingByType(var a, var b) {
  return b['type'].compareTo(a['type']);
}

int ascendingByType(var a, var b) {
  return a['type'].compareTo(b['type']);
}

class MyDB {
  MyDB();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localDBFile async {
    final path = await _localPath;
    return File('$path/$myDBFilePath');
  }

  Future<List> readMyDB() async {
    try {
      final file = await _localDBFile;

      if (readMyDBCalled) return currentData;
      final contents = await file.readAsString();
      List readData = jsonDecode(contents);

      currentData.addAll(readData);

      readMyDBCalled = true;
      return currentData;
    } catch (e) {
      // If encountering an error, return 0
      print('readMyDB catch');
      return [];
    }
  }

  Future<File> writeMyDB(String date, String type, int count, int price) async {
    final file = await _localDBFile;

    // Write the file
    String newDataId = DateFormat('yMMddHHmmssS').format(DateTime.now());

    Data data =
        Data(id: newDataId, date: date, type: type, count: count, price: price);
    currentData.add(data.toJson());

    return file.writeAsString(dataToJson(data));
  }

  Future<File> deleteMyDB(deleteData) async {
    final file = await _localDBFile;

    // Write the file
    currentData.removeWhere((element) => element['id'] == deleteData['id']);

    String modifiedDataStr = jsonEncode(currentData);
    return file.writeAsString(modifiedDataStr);
  }

  Future<File> resetMyDB() async {
    final file = await _localDBFile;

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

    return selectedList;
  }

  int getDataTypeCountOfDay(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now) &&
          element['type'] == type) {
        sum += element['count'] as int;
      }
    });

    return sum;
  }

  int getDataListCountOfDay(DateTime now) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        sum += element['count'] as int;
      }
    });

    return sum;
  }

  int getSumPriceOfDay(DateTime now) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        sum += element['price'] as int;
      }
    });

    return sum;
  }


  int getDataTypeCountOfMonth(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'].startsWith(DateFormat('y-MM').format(now)) &&
          element['type'] == type) {
        sum += element['count'] as int;
      }
    });

    return sum;
  }

  int getSumPriceByTypeOfMonth(DateTime now, String type) {
    int sum = 0;

    currentData.forEach((element) {
      if (element['date'].startsWith(DateFormat('y-MM').format(now)) &&
          element['type'] == type) {
        sum += element['price'] as int;
      }
    });

    return sum;
  }

  void setDataSortType(int selectedSortType) {
    sortType = selectedSortType;
  }
}

class MyConfig{
  MyConfig() {
    _config = Config(lastInputMode: false);
  }

  late Config _config;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localConfigFile async {
    final path = await _localPath;
    return File('$path/$myConfigFilePath');
  }

  Future<void> readMyConfig() async {
    try {
      final file = await _localConfigFile;

      if (readMyConfigCalled) return;

      final contents = await file.readAsString();
      _config = configFromJson(contents);
      readMyConfigCalled = true;
    } catch (e) {
      // If encountering an error, return 0
      print('readMyConfig catch');
      return;
    }
  }

  Future<void> writeMyConfig({bool? lastInputMode}) async {
    final file = await _localConfigFile;

    // Write the file
    if(lastInputMode != null){
      _config.lastInputMode = true;
    }

    await file.writeAsString(configToJson(_config));
  }

  Config get config => _config;
}