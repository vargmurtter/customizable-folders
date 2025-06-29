import 'package:flutter/material.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({super.key, required this.name, this.onSelected});

  final String name;
  final Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onSelected == null) return;
        onSelected!(name);
      },
      child: Image.asset('assets/folder-$name.png'),
    );
  }
}
