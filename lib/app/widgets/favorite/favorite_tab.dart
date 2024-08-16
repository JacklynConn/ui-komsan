import 'package:flutter/material.dart';

import '../subtitle_widget.dart';

class FavoriteTab extends StatelessWidget {

  final String tabLabel;

  const FavoriteTab({super.key, required this.tabLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:40,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
              Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              offset: const Offset(1, 1),
              blurRadius: 2.0,),
          ]
      ),
      child: SubtitleWidget(
        label: tabLabel,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
