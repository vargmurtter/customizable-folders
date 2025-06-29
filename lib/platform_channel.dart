import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel(
  'com.vargmurtter.customizableFolders/folder_icon',
);

Future<void> changeFolderIcon(String folderPath, String icnsPath) async {
  try {
    await platform.invokeMethod('changeFolderIcon', {
      'folderPath': folderPath,
      'icnsPath': icnsPath,
    });
  } on PlatformException catch (e) {
    debugPrint("Ошибка при изменении иконки: ${e.message}");
  }
}
