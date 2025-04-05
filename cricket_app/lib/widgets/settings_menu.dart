import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final void Function(String) onOptionSelected;

  const SettingsMenu({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: onOptionSelected,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'theme',
          child: Text('Change Theme'),
        ),
        PopupMenuItem(
          value: 'language',
          child: Text('Change Language'),
        ),
      ],
    );
  }
}
