// add IT-129-Pithak-2024-05-21

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../subtitle_widget.dart';


class CardHorizontal extends StatelessWidget {

  final void Function() onTap;
  final String image;
  final String name;
  final String location ;
  final String rating;
  final Widget Function (BuildContext, String, Object)? errorWidget;

  const CardHorizontal({
    super.key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    this.errorWidget,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 130,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              offset: const Offset(2, 2),
              spreadRadius: 0.5,
              blurRadius: 3.0,),
          ],),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 110,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.transparent,
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
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name, style: const TextStyle(
                      fontFamily: 'GeneralFont',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8.0,),
                      Text(location, style: const TextStyle(
                          fontFamily: 'GeneralFont',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.visible
                      ),),
                    ],
                  ),
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
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
