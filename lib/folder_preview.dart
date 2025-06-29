import 'package:flutter/material.dart';

import 'folder_item.dart';
import 'meta_file_service.dart';
import 'meta_model.dart';

class FolderPreview extends StatefulWidget {
  const FolderPreview({
    super.key,
    required this.path,
    this.selectedBackgroundName,
    this.onSymbolChanged,
  });

  final String path;
  final String? selectedBackgroundName;
  final Function(String)? onSymbolChanged;

  @override
  State<FolderPreview> createState() => _FolderPreviewState();
}

class _FolderPreviewState extends State<FolderPreview> {
  MetaModel? _meta;

  final TextEditingController _symbolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  void dispose() {
    _symbolController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FolderPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedBackgroundName != oldWidget.selectedBackgroundName) {
      setState(() {});
    }
  }

  Future<void> _asyncInit() async {
    final metaService = MetaFileService(folderPath: widget.path);
    final meta = await metaService.get();
    if (meta.symbol != null) _symbolController.text = meta.symbol!;
    setState(() => _meta = meta);
  }

  @override
  Widget build(BuildContext context) {
    if (_meta == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          FolderItem(
            name: widget.selectedBackgroundName ?? _meta!.backgroundName,
          ),
          Center(
            child: TextField(
              controller: _symbolController,
              onChanged: (value) {
                if (value.characters.isNotEmpty) {
                  final firstChar = value.characters.first;
                  _symbolController.text = firstChar;
                  _symbolController.selection = TextSelection.collapsed(
                    offset: firstChar.length,
                  );
                  if (widget.onSymbolChanged != null) {
                    widget.onSymbolChanged!(firstChar);
                  }
                } else {
                  _symbolController.text = '';
                  if (widget.onSymbolChanged != null) {
                    widget.onSymbolChanged!('');
                  }
                }
              },
              style: TextStyle(fontSize: 125, color: Colors.white),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
