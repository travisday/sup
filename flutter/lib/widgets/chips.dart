import 'package:flutter/material.dart';

class Chips extends StatelessWidget {
  final int _selected;
  final List<String> items;
  final Function(int index) onSelected;

  const Chips(
    this._selected,
    this.items,
    this.onSelected, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List<Widget>.generate(
        items.length,
        (int index) {
          return ChoiceChip(
            label: Text(items[index]),
            selected: _selected == index,
            onSelected: (bool selected) {
              this.onSelected(index);
            },
          );
        },
      ).toList(),
    );
  }
}
