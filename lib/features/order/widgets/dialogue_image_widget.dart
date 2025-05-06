import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/camera_button_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogImageWidget extends StatelessWidget {
  const DialogImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white54),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'take_a_picture'.tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            GetBuilder<OrderController>(builder: (orderController) {
              return InkWell(
                onTap: () {
                  Get.bottomSheet(const CameraButtonSheetWidget());
                },
                child: Container(
                  height: 100, width: 150, alignment: Alignment.center, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                  child:  Icon(Icons.camera_alt_sharp, color: Theme.of(context).primaryColor, size: 32),
                ),
              );
            }),

          ]),
        ),
      ]),
    );
  }
}