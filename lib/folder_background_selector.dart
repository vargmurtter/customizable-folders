import 'package:flutter/material.dart';

import 'folder_item.dart';

class FolderBackgroundSelector extends StatelessWidget {
  const FolderBackgroundSelector({super.key, required this.onSelected});

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: [
        FolderItem(name: 'black', onSelected: onSelected),
        FolderItem(name: 'blue', onSelected: onSelected),
        FolderItem(name: 'gray', onSelected: onSelected),
        FolderItem(name: 'green', onSelected: onSelected),
        FolderItem(name: 'lime', onSelected: onSelected),
        FolderItem(name: 'orange', onSelected: onSelected),
        FolderItem(name: 'purple', onSelected: onSelected),
        FolderItem(name: 'red', onSelected: onSelected),
        FolderItem(name: 'yellow', onSelected: onSelected),
      ],
    );
  }
}
