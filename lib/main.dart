import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'folder_background_selector.dart';
import 'folder_drop_zone.dart';
import 'folder_preview.dart';
import 'meta_file_service.dart';
import 'meta_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Customizable Folders");
    setWindowMinSize(Size(300, 600));
    setWindowMaxSize(Size(300, 600));
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? _folderPath;
  String? _selectedBackgroundName;
  String? _selectedSymbol;

  void _resetState() {
    setState(() {
      _folderPath = null;
      _selectedBackgroundName = null;
      _selectedSymbol = null;
    });
  }

  Future<void> _onFolderDropped(String path) async {
    final metaService = MetaFileService(folderPath: path);
    final meta = await metaService.get();

    setState(() {
      _selectedBackgroundName = meta.backgroundName;
      _selectedSymbol = meta.symbol;
      _folderPath = path;
    });
  }

  Future<void> _updateMetaFile() async {
    if (_folderPath == null || _selectedBackgroundName == null) {
      return;
    }
    final metaService = MetaFileService(folderPath: _folderPath!);

    await metaService.update(
      MetaModel(
        backgroundName: _selectedBackgroundName!,
        symbol: _selectedSymbol,
      ),
    );
    await metaService.setIcon(_selectedBackgroundName!, _selectedSymbol);
  }

  Future<void> _removeMetaFile() async {
    if (_folderPath == null) {
      return;
    }
    final metaService = MetaFileService(folderPath: _folderPath!);
    await metaService.remove();

    _resetState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _folderPath == null
                  ? FolderDropZone(onFolderDropped: _onFolderDropped)
                  : FolderPreview(
                      path: _folderPath!,
                      selectedBackgroundName: _selectedBackgroundName,
                      onSymbolChanged: (symbol) => _selectedSymbol = symbol,
                    ),

              Row(
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.doc),
                    onPressed: _resetState,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(CupertinoIcons.floppy_disk),
                    onPressed: _updateMetaFile,
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.refresh_thick),
                    onPressed: _removeMetaFile,
                  ),
                ],
              ),
              Expanded(
                child: FolderBackgroundSelector(
                  onSelected: (name) {
                    setState(() {
                      _selectedBackgroundName = name;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
