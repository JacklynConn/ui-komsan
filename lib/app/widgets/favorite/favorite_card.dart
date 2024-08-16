import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../subtitle_widget.dart';

class FavoriteCard extends StatelessWidget {

  final void Function() onTap;
  final String image;
  final String name;
  final String location;
  final String rating;
  final void Function() onPress;

  const FavoriteCard({
    super.key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(left: 4.0, right: 4.0,),
        height: 130,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              offset: const Offset(1, 1),
              spreadRadius: 0.3,
              blurRadius: 4.0,),
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
                    child: CircularProgressIndicator(color: Colors.blueAccent,),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent,),
                  );
                },
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
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      const SizedBox(width: 8.0,),
                      SizedBox(
                        width: 90,
                        child: Text(location, style: const TextStyle(
                            fontFamily: 'GeneralFont',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
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
            ),
            IconButton(
              onPressed: onPress,
              icon: const Icon(Icons.delete,
              size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
