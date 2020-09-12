import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/number.txt');
  }

  Future<int> readNumber() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeNumber(int number) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$number');
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
