import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'meta_model.dart';
import 'platform_channel.dart';
import 'utils.dart';

class MetaFileService {
  final String folderPath;

  MetaFileService({required this.folderPath});

  Future<MetaModel> get() async {
    final metaFilePath = "$folderPath/.cf_meta";
    final metaFile = File(metaFilePath);
    final fileExists = await metaFile.exists();

    if (!fileExists) {
      final json = jsonEncode(MetaModel(backgroundName: 'blue').toMap());
      await metaFile.writeAsString(json);
    }

    final metaJson = await metaFile.readAsString();
    return MetaModel.fromMap(jsonDecode(metaJson));
  }

  Future<void> update(MetaModel updatedMeta) async {
    final json = jsonEncode(updatedMeta.toMap());
    final metaFilePath = "$folderPath/.cf_meta";
    final metaFile = File(metaFilePath);
    await metaFile.writeAsString(json);
  }

  Future<void> setIcon(String backgroundName, String? symbol) async {
    final byteData = await rootBundle.load('assets/folder-$backgroundName.png');
    final backgroundBytes = byteData.buffer.asUint8List();
    final pngIconPath = "$folderPath/.cf_icon.png";
    final pngIconFile = File(pngIconPath);
    await pngIconFile.writeAsBytes(backgroundBytes);

    await resizeImage(pngIconPath, pngIconPath, 512);

    if (symbol != null) {
      final pngIconBytes = await pngIconFile.readAsBytes();
      final emojiIconBytes = await addEmojiToImage(symbol, pngIconBytes);
      await pngIconFile.writeAsBytes(emojiIconBytes);
    }

    final icnsPath = "$folderPath/.cf_icon.icns";
    await Process.run('sips', [
      '-s',
      'format',
      'icns',
      pngIconPath,
      '--out',
      icnsPath,
    ]);

    await changeFolderIcon(folderPath, icnsPath);

    await pngIconFile.delete();

    final icnsFile = File(icnsPath);
    await icnsFile.delete();
  }

  Future<void> remove() async {
    final iconFile = File('$folderPath/Icon\r');
    if (await iconFile.exists()) {
      await iconFile.delete();
    }

    final metaFile = File('$folderPath/.cf_meta');
    if (await metaFile.exists()) {
      await metaFile.delete();
    }
  }
}
