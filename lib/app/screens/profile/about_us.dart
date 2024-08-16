import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/widgets/subtitle_widget.dart';
import 'package:ui_komsan/app/widgets/title_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmore/readmore.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'About Us'.tr,
          color: Colors.blueAccent,
          fontSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SubtitleWidget(
                label: 'Komsan App',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: const ReadMoreText(
                  'This app is designed to make it effortless for travelers to discover and navigate local places,'
                  'hotels, and restaurants during their journeys. Whether exploring new cities or supporting local businesses, '
                  'our user-friendly interface provides detailed maps and insights into nearby attractions and services. '
                  'By promoting local establishments through real-time updates and personalized recommendations, '
                  'travelers can confidently plan their adventures while contributing to the vitality of local economies. '
                  'Welcome to your essential travel companion, simplifying your exploration and fostering economic growth in every community you visit.',
                  trimMode: TrimMode.Line,
                  trimLines: 5,
                  textAlign: TextAlign.justify,
                  delimiter: '...',
                  isExpandable: true,
                  trimCollapsedText: 'See more',
                  trimExpandedText: 'See less',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GeneralFont',
                  ),
                  moreStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'GeneralFont',
                  ),
                  lessStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'GeneralFont',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const SubtitleWidget(
                label: 'Teacher Lead Project',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'GeneralFont',
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/developers/teacher.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'assets/images/developers/teacher.jpg',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SubtitleWidget(
                label: 'Mr. Peng Bunchheang',
                fontSize: 16,
              ),
              const SizedBox(height: 40),
              const SubtitleWidget(
                label: 'Team Members',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAvatarWithText(
                      context,
                      'assets/images/developers/mach.jpg',
                      'Mak Mach',
                    ),
                    const SizedBox(width: 6),
                    _buildAvatarWithText(
                      context,
                      'assets/images/developers/pithak.jpg',
                      'Hor Sovathapithak',
                    ),
                    const SizedBox(width: 6),
                    _buildAvatarWithText(
                      context,
                      'assets/images/developers/tongheng.jpg',
                      'Kry Tongheng',
                    ),
                    const SizedBox(width: 6),
                    _buildAvatarWithText(
                      context,
                      'assets/images/developers/rithy.jpg',
                      'Khoun Rithy',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const SubtitleWidget(
                  fontSize: 12,
                  label: 'For more information, please contact us at '),
              GestureDetector(
                onTap: () {
                  _launchPhone('+85510924641');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tel: +85510924641 ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontFamily: 'GeneralFont',
                        ), // Highlight color
                      ),
                      // TextSpan(
                      //   text: 'Copyright © 2024. All Rights Reserved.',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     fontFamily: 'GeneralFont',
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SubtitleWidget(
                fontSize: 12,
                label: 'Copyright © 2024. All Rights Reserved.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWithText(
      BuildContext context, String imagePath, String text) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        const SizedBox(height: 8),
        SubtitleWidget(
          label: text,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
