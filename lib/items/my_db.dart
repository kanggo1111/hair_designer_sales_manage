import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

const MY_DATABASE_FILE_PATH = 'my_database.txt';

class MyDB{
  List<dynamic> currentData = List.empty(growable: true);

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

      currentData.addAll(readData);
      print('R '+ currentData.toString());
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

    print('W1 '+ currentData.toString());
    //print('W2 '+ newData.toString());

    //currentData.add(newData);
    //print('W3 '+ currentData.toString());

    //String modifiedDataStr = jsonEncode(currentData);
    //return file.writeAsString(modifiedDataStr);

    return file.writeAsString('', mode: FileMode.append);
  }

  Future<File> resetMyDB() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('[]');
  }
}