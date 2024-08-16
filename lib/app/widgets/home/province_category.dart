import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProvinceCategory extends StatelessWidget {

  final void Function() onTap;
  final String image;
  final String name;
  final Widget Function (BuildContext, String, Object)? errorWidget;

  const ProvinceCategory({
    super.key,
    required this.onTap,
    required this.image,
    required this.name,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        margin: const EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
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
              flex: 3,
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: errorWidget
                ),
              ),
            ),
            Expanded(
              flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Column(
                    children: [
                      Center(
                        child: Text(name, style: const TextStyle(
                            fontFamily: 'GeneralFont',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            const SizedBox(height: 8.0,)
          ],
        ),
      ),
    );
  }
}
