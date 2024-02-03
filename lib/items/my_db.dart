import 'dart:io';
import 'package:path_provider/path_provider.dart';

const MY_DATABASE_FILE_PATH = 'my_database.txt';

class MyDB{
  MyDB();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$MY_DATABASE_FILE_PATH');
  }

  Future<String> readMyDB() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      print(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'error';
    }
  }

  Future<File> writeMyDB(newData) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(newData+',\n', mode: FileMode.append);
  }

  Future<File> resetMyDB() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('');
  }
}