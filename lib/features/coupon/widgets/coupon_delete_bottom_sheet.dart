import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class CouponDeleteBottomSheet extends StatelessWidget {
  final int couponId;
  const CouponDeleteBottomSheet({super.key, required this.couponId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<CouponController>(builder: (couponController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 35),

          const CustomAssetImageWidget(
            image: Images.warning, height: 50, width: 50,
          ),
          const SizedBox(height: 35),

          Text('are_you_sure'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text('you_want_to_delete_this_coupon'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 50),

          Row(children: [

            Expanded(
              child: !couponController.isLoading ? CustomButtonWidget(
                onPressed: () {
                  couponController.deleteCoupon(couponId);
                },
                buttonText: 'delete'.tr,
                color: Theme.of(context).colorScheme.error,
              ) : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomButtonWidget(
                onPressed: () {
                  Get.back();
                },
                buttonText: 'cancel'.tr,
                color: Theme.of(context).disabledColor.withOpacity(0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

          ]),

        ]);
      }),
    );
  }
}
