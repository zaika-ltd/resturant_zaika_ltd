import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/package_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/renew_subscription_plan_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/subscription_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ChangeSubscriptionPlanBottomSheet extends StatefulWidget {
  final bool businessIsCommission;
  const ChangeSubscriptionPlanBottomSheet({super.key, required this.businessIsCommission});

  @override
  State<ChangeSubscriptionPlanBottomSheet> createState() => _ChangeSubscriptionPlanBottomSheetState();
}

class _ChangeSubscriptionPlanBottomSheetState extends State<ChangeSubscriptionPlanBottomSheet> {

  SwiperController swiperController = SwiperController();
  int activePackageIndex = -1;
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    if(Get.find<SubscriptionController>().packageList == null) {
      isFirstTime = true;
    }
    await Get.find<SubscriptionController>().getPackageList().then((value) {
      if(Get.find<SubscriptionController>().packageList!.isNotEmpty){
        Future.delayed(Duration(seconds: isFirstTime ? 1 : 0), () {
          swiperController.move(activePackageIndex);
        });
      }
    });
    Get.find<SubscriptionController>().initializeRenew();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController) {

      bool businessIsCommission = subscriptionController.profileModel!.restaurants![0].restaurantBusinessModel == 'commission';
      bool businessIsUnsubscribed = subscriptionController.profileModel!.restaurants![0].restaurantBusinessModel == 'unsubscribed';
      bool businessIsNone = subscriptionController.profileModel!.restaurants![0].restaurantBusinessModel == 'none';

      if(subscriptionController.packageList != null){
        for (var element in subscriptionController.packageList!) {
          if(subscriptionController.profileModel!.subscription != null){
            if(subscriptionController.profileModel!.subscription!.package!.id == element.id){
              activePackageIndex = subscriptionController.packageList!.indexOf(element);
              if (kDebugMode) {
                print('active package : $activePackageIndex');
              }
            }
          }
        }
      }

      return  subscriptionController.packageList != null ? Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),

          Text(
            (businessIsNone || (businessIsUnsubscribed && (subscriptionController.profileModel?.subscription == null))) ? 'chose_a_business'.tr : 'change_subscription_plan'.tr,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text(
            (businessIsNone || (businessIsUnsubscribed && (subscriptionController.profileModel?.subscription == null))) ? 'chose_a_business_plan_to_get_better_experience'.tr : 'renew_or_shift_your_plan_to_get_better_experience'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5)),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

           SizedBox(
             height: 470,
             child: subscriptionController.packageList!.isNotEmpty ? Swiper(
               itemCount: subscriptionController.packageList!.length,
               viewportFraction: subscriptionController.packageList!.length > 1 ? 0.60 : 1,
               physics: subscriptionController.packageList!.length > 1 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
               controller: swiperController,
               onIndexChanged: (index) {
                 subscriptionController.selectSubscriptionCard(index);
                 subscriptionController.activePackage(activePackageIndex == index);
               },
               itemBuilder: (context, index) {

                 Packages package = subscriptionController.packageList![index];
                 bool isCommission = package.id == -1;

                 return Stack(children: [

                   PackageCardWidget(
                     currentIndex: subscriptionController.activeSubscriptionIndex == index ? index : null,
                     package: package, fromChangePlan: true,
                   ),

                   Positioned(
                     bottom: 0, left: 0, right: 0,
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverLarge, vertical: Dimensions.paddingSizeLarge),
                       child: !subscriptionController.isLoading ? CustomButtonWidget(
                         color: subscriptionController.activeSubscriptionIndex == index ? Theme.of(context).primaryColor : const Color(0xff334257),
                         buttonText: (subscriptionController.isActivePackage != null && subscriptionController.isActivePackage! && activePackageIndex != -1 && (!isCommission && !widget.businessIsCommission))
                             ? 'renew'.tr : (isCommission && widget.businessIsCommission) ? 'current_plan'.tr : (businessIsNone || (businessIsUnsubscribed && (subscriptionController.profileModel?.subscription == null))) ? 'purchase'.tr : 'shift_this_plan'.tr,
                         radius: Dimensions.radiusDefault,
                         onPressed: (isCommission && widget.businessIsCommission) ? null : () {

                           if(((subscriptionController.isActivePackage! && activePackageIndex != -1) && (businessIsUnsubscribed || businessIsNone))
                            || (businessIsUnsubscribed && (subscriptionController.profileModel!.subscription == null)
                            && (Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0) && (Get.find<AuthController>().packageModel != null && Get.find<AuthController>().packageModel!.packages!.isNotEmpty)) || businessIsNone) {
                             showCustomBottomSheet(
                               child: RenewSubscriptionPlanBottomSheet(
                                 isRenew: true,
                                 package: package,
                                 checkProductLimitModel: null,
                                 nonSubscription: businessIsNone || (businessIsUnsubscribed && (subscriptionController.profileModel?.subscription == null)),
                               ),
                             );
                           }else if((isCommission && (businessIsUnsubscribed || businessIsNone)) || isCommission) {
                             Get.dialog(SubscriptionDialogWidget(
                               icon: Images.support,
                               title: 'are_you_sure'.tr,
                               description: 'you_want_to_migrate_to_commission'.tr,
                               onYesPressed: () {
                                 subscriptionController.renewBusinessPlan(restaurantId: subscriptionController.profileModel!.restaurants![0].id.toString(), isCommission: true);
                               },
                             ), useSafeArea: false);
                           } else {
                             subscriptionController.getProductLimit(
                               restaurantId: subscriptionController.profileModel!.restaurants![0].id!,
                               packageId: package.id!,
                               activePackage: subscriptionController.packageList![businessIsCommission ? subscriptionController.activeSubscriptionIndex : activePackageIndex],
                               package: package,
                             );
                           }
                         },
                       ) : const Center(child: SizedBox(height: 35, width: 35, child: CircularProgressIndicator(color: Colors.white))),
                     ),
                   ),

                 ]);
               },
              ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('no_package_available'.tr)])),
           ),

          const SizedBox(height: 40),

        ]),
      ) : const Center(child: CircularProgressIndicator());
    });
  }
}
