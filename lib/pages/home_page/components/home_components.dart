import 'dart:io';

import 'package:ambros_app/utils/base_components.dart';
import 'package:path_provider/path_provider.dart';

class HomeComponent extends BaseComponents{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/a.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<File> writeValue(String value) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$value');
  }
}