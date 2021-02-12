import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Service {
  bool _status;
  File _file;

  Service() {
    _status = false;
  }

  Future<bool> _checkFile() async {
    if (_file == null) {
      String documentsPath = (await getApplicationSupportDirectory()).path;
      _file = new File('$documentsPath/status.bin');
    }

    if (!(await _file.exists())) {
      await _file.create();
      await _file.writeAsString("false");
      return false;
    } else
      return true;
  }

  Future<void> restoreStatus() async {
    if (await _checkFile())
      _status = (await _file.readAsString()) == "true";
    else
      _status = false;
  }

  String get status => _status ? "online" : "offline";

  Future<void> changeStatus() async {
    _status = !_status;

    await _checkFile();

    _file.writeAsString(_status.toString());
  }
}
