import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class FolderDropZone extends StatefulWidget {
  const FolderDropZone({super.key, this.onFolderDropped});

  final Function(String)? onFolderDropped;

  @override
  State<FolderDropZone> createState() => _FolderDropZoneState();
}

class _FolderDropZoneState extends State<FolderDropZone> {
  void _onDragDone(DropDoneDetails details) {
    if (details.files.isEmpty) return;

    final file = details.files[0];

    final path = file.path;
    final entity = FileSystemEntity.typeSync(path);
    if (entity != FileSystemEntityType.directory) return;

    if (widget.onFolderDropped != null) widget.onFolderDropped!(path);
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: _onDragDone,
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.grey[200],
            child: Center(child: Text('Drop folder here')),
          ),
        ],
      ),
    );
  }
}
