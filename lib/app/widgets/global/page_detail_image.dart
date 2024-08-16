// add IT-139-Pithak-2024-05-21

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PageDetailImage extends StatelessWidget {

  final String imageUrl;
  final Widget Function (BuildContext, String, Object)? errorWidget;
  const PageDetailImage({
    super.key,
    required this.imageUrl,
    this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            spreadRadius: -9,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const Center(
              child:  CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          },
          errorWidget: errorWidget,
        ),
      ),
    );
  }
}
