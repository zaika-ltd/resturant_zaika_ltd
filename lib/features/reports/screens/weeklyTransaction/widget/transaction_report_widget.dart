import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_date_wise.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionReportDetail extends StatelessWidget {
  final ReportSummary orderTransactions;

  const TransactionReportDetail({super.key, required this.orderTransactions});

  // Helper widget to build each row with an icon
  Widget _buildReportRow(BuildContext context,
      {required IconData icon,
      required String title,
      required double amount,
      Color? amountColor}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
      trailing: Text(
        amount.toStringAsFixed(2),
        style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: amountColor ?? Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Helper widget for group titles
  Widget _buildGroupTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Dimensions.paddingSizeLarge,
          bottom: Dimensions.paddingSizeSmall),
      child: Text(
        title,
        style: robotoBold.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).disabledColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeExtraLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge),
          topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- REVENUE GROUP ---
            _buildGroupTitle(context, "REVENUE DETAILS"),
            _buildReportRow(context,
                icon: Icons.receipt_long,
                title: 'total_food_amount'.tr,
                amount: orderTransactions.totalItemAmount),
            _buildReportRow(context,
                icon: Icons.delivery_dining,
                title: 'delivery_charge'.tr,
                amount: orderTransactions.deliveryCharge),
            _buildReportRow(context,
                icon: Icons.add_box_outlined,
                title: 'additional_charge'.tr,
                amount: orderTransactions.additionalCharge),
            _buildReportRow(context,
                icon: Icons.summarize,
                title: 'order_amount'.tr,
                amount: orderTransactions.orderAmount),

            // --- DEDUCTIONS GROUP ---
            _buildGroupTitle(context, "DEDUCTIONS & DISCOUNTS"),
            _buildReportRow(context,
                icon: Icons.local_offer,
                title: 'food_discount'.tr,
                amount: orderTransactions.itemDiscount,
                amountColor: Colors.orange),
            _buildReportRow(context,
                icon: Icons.sell,
                title: 'coupon_discount'.tr,
                amount: orderTransactions.couponDiscount,
                amountColor: Colors.orange),
            _buildReportRow(context,
                icon: Icons.shield,
                title: 'admin_discount'.tr,
                amount: orderTransactions.adminDiscount,
                amountColor: Colors.orange),
            _buildReportRow(context,
                icon: Icons.storefront,
                title: 'restaurant_discount'.tr,
                amount: orderTransactions.restaurantDiscount,
                amountColor: Colors.orange),

            // --- FEES & TAXES GROUP ---
            _buildGroupTitle(context, "FEES & TAXES"),
            _buildReportRow(context,
                icon: Icons.policy,
                title: 'vat_tax'.tr,
                amount: orderTransactions.vat,
                amountColor: Colors.red),
            _buildReportRow(context,
                icon: Icons.cut,
                title: 'admin_commission'.tr,
                amount: orderTransactions.adminCommission,
                amountColor: Colors.red),
            _buildReportRow(context,
                icon: Icons.local_shipping,
                title: 'commission_on_delivery_charge'.tr,
                amount: orderTransactions.commissionOnDeliveryCharge,
                amountColor: Colors.red),

            const Divider(height: 40),

            // --- FINAL INCOME ---
            _buildReportRow(context,
                icon: Icons.account_balance_wallet,
                title: 'restaurant_net_income'.tr,
                amount: orderTransactions.restaurantNetIncome,
                amountColor: Colors.green),
          ],
        ),
      ),
    );
  }
}
