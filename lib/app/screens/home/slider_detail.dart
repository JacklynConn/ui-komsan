import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/global_config.dart';
import '../../models/slider_model.dart';

class SliderDetailPage extends StatelessWidget {
  final SliderModel slider;

  SliderDetailPage({required this.slider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(slider.title ?? 'Slider Detail'), // Dynamic title based on slider's title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Image on the top
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  _navigateToFullScreenImage(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.grey[300]!, // Adjust border color as needed
                        width: 1.0, // Adjust border width as needed
                      ),
                    ),
                    child: (slider.image != null && slider.image!.isNotEmpty)
                        ? CachedNetworkImage(
                      imageUrl: '$baseUrl${slider.image}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                        : Placeholder(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Title and Description
          Expanded(
            flex: 2, // Adjusted flex value for title and description
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    (slider.title != null && slider.title!.isNotEmpty)
                        ? slider.title!
                        : "No Title",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    (slider.description != null && slider.description!.isNotEmpty)
                        ? slider.description!
                        : "No Description",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(slider.title ?? 'Full Screen Image'), // Dynamic title based on slider's title
          ),
          body: Center(
            child: CachedNetworkImage(
              imageUrl: '$baseUrl${slider.image}',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
