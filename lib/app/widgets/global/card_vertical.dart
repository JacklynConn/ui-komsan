// add IT-129-Pithak-2024-05-21

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../subtitle_widget.dart';


class CardVertical extends StatelessWidget {

  final void Function() onTap;
  final String image;
  final String name;
  final String location;
  final String rating;
  final Widget Function (BuildContext, String, Object)? errorWidget;

  const CardVertical({
    super.key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    this.errorWidget,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        margin: const EdgeInsets.only(bottom: 8.0),
        width: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              offset: const Offset(2, 2),
              spreadRadius: 0.5,
              blurRadius: 3.0,
            ),],),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: 140,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  },
                  errorWidget: errorWidget,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(
                        fontFamily: 'GeneralFont',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                    ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 4.0,),
                        Text(location, style: const TextStyle(
                            fontFamily: 'GeneralFont',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                       const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 5,),
                        SubtitleWidget(
                          label: rating,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
