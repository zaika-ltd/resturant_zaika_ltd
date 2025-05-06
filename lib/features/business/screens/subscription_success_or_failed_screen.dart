import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class SubscriptionSuccessOrFailedScreen extends StatefulWidget {
  final bool success;
  final bool fromSubscription;
  final int? restaurantId;
  final int? packageId;
  const SubscriptionSuccessOrFailedScreen({super.key, required this.success, required this.fromSubscription, this.restaurantId, this.packageId});

  @override
  State<SubscriptionSuccessOrFailedScreen> createState() => _SubscriptionSuccessOrFailedScreenState();
}

class _SubscriptionSuccessOrFailedScreenState extends State<SubscriptionSuccessOrFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if(widget.success) {
          Get.find<AuthController>().saveIsRestaurantRegistrationSharedPref(true);
          Get.offAllNamed(RouteHelper.getSignInRoute());
        } else {
          Get.offAllNamed(RouteHelper.getSubscriptionPaymentRoute(restaurantId: widget.restaurantId, packageId: widget.packageId));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [

            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeOverExtraLarge, bottom: Dimensions.paddingSizeLarge,
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text(
                      'restaurant_registration'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),

                    Text(
                      widget.success ? 'registration_success'.tr : 'transaction_failed'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    LinearProgressIndicator(
                      backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                      value: widget.success ? 1 : 0.75,
                    ),

                  ]),
                ),
                SizedBox(height: context.height * 0.2),

                Column(children: [

                  CustomAssetImageWidget(
                    image: widget.success ? Images.checkGif : Images.cancelGif,
                    height: 100,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: widget.success ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        '${'congratulations'.tr}!',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      SizedBox(
                        width: context.width,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(style: robotoRegular.copyWith(color: Theme.of(context).hintColor, height: 1.7), children: [
                            TextSpan(text: widget.fromSubscription ? 'subscription_success_message'.tr : 'commission_base_success_message'.tr),
                          ]),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeOverLarge),

                      TextButton(
                        onPressed: () {
                          Get.find<AuthController>().saveIsRestaurantRegistrationSharedPref(true);
                          Get.offAllNamed(RouteHelper.getSignInRoute());
                        },
                        child: Text(
                          'continue_to_home_page'.tr,
                          style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                              decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                        ),
                      ),

                    ]) : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Text(
                        '${'transaction_failed'.tr}!',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      SizedBox(
                        width: context.width,
                        child: Text(
                          'sorry_your_transaction_can_not_be_completed_please_choose_another_payment_method_or_try_again'.tr,
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(RouteHelper.getSubscriptionPaymentRoute(restaurantId: widget.restaurantId, packageId: widget.packageId));
                        },
                        child: Text(
                          'try_again'.tr,
                          style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                              decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                        ),
                      ),

                    ]),
                  ),
                ]),

              ]),
            ),

          ]),
        ),
      ),
    );
  }
}
