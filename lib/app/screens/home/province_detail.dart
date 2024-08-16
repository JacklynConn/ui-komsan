import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/constants/global_config.dart';
import 'package:ui_komsan/app/widgets/title_text_widget.dart';


import '../../controllers/province_controller.dart';
import '../place/place_in_province_screen.dart';

class ProvinceDetail extends StatelessWidget {
  final provinceController = Get.put(ProvinceController());

  ProvinceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'Province'.tr,
          fontSize: 18,
          color: Colors.blueAccent,
        ),
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24,),
          color: Colors.blueAccent,
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provinceController.provinces.length,
        itemBuilder: (context, index) {
          var province = provinceController.provinces[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => PlaceInProvinceScreen(province: province),);
                  },
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
                            imageUrl: '$baseUrl${province.provinceImage}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Center(
                                child: Icon(Icons.error_outline,
                                  color: Colors.blueAccent,),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(province.provinceNameen!, style: const TextStyle(
                                  fontFamily: 'GeneralFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                              ),
                              Text(province.provinceNamekh!, style: const TextStyle(
                                  fontFamily: 'GeneralFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
