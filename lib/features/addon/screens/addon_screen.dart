import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/widgets/add_addon_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/widgets/addon_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonScreen extends StatelessWidget {
  const AddonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AddonController>().getAddonList();

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'addons'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
            Get.bottomSheet(const AddAddonBottomSheetWidget(addon: null), isScrollControlled: true, backgroundColor: Colors.transparent);
          }else {
            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
          }
        },
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),

      body: GetBuilder<AddonController>(builder: (addonController) {
        return addonController.addonList != null ? addonController.addonList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await addonController.getAddonList();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: addonController.addonList!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                color: index % 2 == 0 ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withOpacity(0.2),
                child: Row(children: [

                  Expanded(child: Text(
                    addonController.addonList![index].name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(
                    addonController.addonList![index].price! > 0 ? PriceConverter.convertPrice(addonController.addonList![index].price) : 'free'.tr,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular, textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                        ),
                      ];
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                    offset: const Offset(-20, 20),
                    child: const Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Icon(Icons.more_vert, size: 25),
                    ),
                    onSelected: (dynamic value) {
                      if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                        if (value == 'edit') {
                          Get.bottomSheet(
                            AddAddonBottomSheetWidget(addon: addonController.addonList![index]),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        } else {
                          showCustomBottomSheet(
                            child: AddonDeleteBottomSheet(addonId: addonController.addonList![index].id!),
                          );
                        }
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                  ),

                ]),
              );
            },
          ),
        ) : Center(child: Text('no_addon_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}