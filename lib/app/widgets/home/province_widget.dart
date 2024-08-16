import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../subtitle_widget.dart';
import '../../screens/home/province_detail.dart';

class ProvinceWidget extends StatelessWidget {
  const ProvinceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          SubtitleWidget(
            label: 'Province'.tr,
            fontSize: 17,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w600,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.to(
                    () => ProvinceDetail(),
                transition: Transition.rightToLeft,
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
