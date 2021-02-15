import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart' as wm;

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

  String get status => _status ? "enabled".tr() : "disabled".tr();

  bool get enabled => _status;

  Future<void> changeStatus() async {
    _status = !_status;

    if (_status)
    {
      await wm.Workmanager.registerPeriodicTask(
        "check",
        "check",
        frequency: Duration(hours: 13),
      );
    }
    else
    {
      await wm.Workmanager.cancelAll();
    }

    await _checkFile();

    _file.writeAsString(_status.toString());
  }
}
