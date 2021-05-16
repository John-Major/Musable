import 'package:flutter/material.dart';
class MusicGrid extends StatelessWidget {
  const MusicGrid(this.measureCount);
  final int measureCount;
  static const _pad = EdgeInsets.all(4);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: measureCount,
      children: List<Widget>.generate(
        measureCount,
          (index) => Container(
            margin: _pad,
            padding: _pad,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.amber,
              ),
                borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.headline4,
              )
            )
          ),
      ),
    );
  }
}