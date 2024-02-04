import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const MY_DATABASE_FILE_PATH = 'my_database.txt';

late MyDB myDB;
List<dynamic> currentData = List.empty(growable: true);

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

      // Read the file
      final contents = await file.readAsString();

      List readData = jsonDecode(contents);

      print('R1 '+currentData.length.toString());
      currentData.forEach((element) {print('R2 '+element.toString());});

      if(readData.length != currentData.length){  // TODO: fix not to overlap on hot reload
        currentData.addAll(readData);
      }
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

    //print('W1 ' + currentData.toString());
    //print('W2 '+ newData.toString());

    currentData.add(newData);
    //print('W3 '+ currentData.toString());

    //String modifiedDataStr = jsonEncode(currentData);
    //return file.writeAsString(modifiedDataStr);

    return file.writeAsString('', mode: FileMode.append);
  }

  Future<File> resetMyDB() async {
    final file = await _localFile;

    file.writeAsString('');
    String testDataSet =
    '[{"date": "2024-02-03", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "지명", "itemName": "커트", "itemPrice": 20000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-03", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "염색", "itemPrice": 48000}, {"date": "2024-02-02", "itemType": "지명", "itemName": "커트", "itemPrice": 20000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "펌", "itemPrice": 56000}, {"date": "2024-02-02", "itemType": "신규", "itemName": "염색", "itemPrice": 48000}]';
    return file.writeAsString(testDataSet);

    // Write the file
    // return file.writeAsString('[]');
  }

  List<dynamic> getDataListOfDay(DateTime now) {
    List<dynamic> selectedList = [];

    currentData.forEach((element) {
      if (element['date'] == DateFormat('y-MM-dd').format(now)) {
        selectedList.add(element);
      }
    });

    // print(selectedList.length);
    // selectedList.forEach((element) {print(selectedList.toString());});

    return selectedList;
  }
}
