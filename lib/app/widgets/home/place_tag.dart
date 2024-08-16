import 'package:flutter/material.dart';
import '../subtitle_widget.dart';

class PlaceTag extends StatelessWidget {

  final String tag;

  const PlaceTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 4,right: 4,
          top: 2,bottom: 2),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              spreadRadius: 0.5,
              blurRadius: 2.0,
            ),
          ]
      ),
      child: SubtitleWidget(
        label: tag,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
