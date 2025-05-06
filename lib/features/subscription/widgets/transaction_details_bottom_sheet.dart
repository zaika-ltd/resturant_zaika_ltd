import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/models/subscription_transaction_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class TransactionDetailsBottomSheet extends StatelessWidget {
  final Transactions transactions;
  const TransactionDetailsBottomSheet({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.07),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
              topRight: Radius.circular(Dimensions.radiusExtraLarge),
            ),
          ),
          child: Column(children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Column(children: [

              Text('${'transaction_successful'.tr}!', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.6))),

              Text('${'for'.tr} ${transactions.package!.packageName} ${'package'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'purchase_status'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                Text(
                  transactions.planType == 'renew' ? 'renewed'.tr : transactions.planType == 'new_plan' ? 'migrated'.tr : transactions.planType == 'free_trial' ? 'free_trial'.tr : 'purchased'.tr,
                  style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(transactions.restaurant?.name ?? '', style: robotoBold.copyWith(fontSize: 15)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: 'thank_you_for_transaction_with'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                  TextSpan(text: ' ${AppConstants.appName} ', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                  TextSpan(text: '${'in'.tr} ${transactions.package!.packageName} ${'package'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                ]),
              ),

            ]),
            const SizedBox(height: 40),

          ]),
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${'transaction_id'.tr} # ', style: robotoRegular),
                  Flexible(child: Text(transactions.id ?? '', style: robotoRegular.copyWith(fontSize: 13.5))),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('package_name'.tr, style: robotoRegular),
                  Text(transactions.package?.packageName ?? '', style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('time'.tr, style: robotoRegular),
                  Text(DateConverter.utcToDate(transactions.createdAt!), style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('validity'.tr, style: robotoRegular),
                  Text('${transactions.validity} ${'days'.tr}', style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('amount'.tr, style: robotoRegular),
                  Text(PriceConverter.convertPrice(transactions.paidAmount), style: robotoRegular),
                ]),
                const SizedBox(height: 40),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}
