class TransactionSummaryModel {
  final int onHold;
  final int canceled;
  final int completedTransactions;
  final ReportSummary summary;

  TransactionSummaryModel({
    required this.onHold,
    required this.canceled,
    required this.completedTransactions,
    required this.summary,
  });

  factory TransactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryModel(
      onHold: json['on_hold'] ?? 0,
      canceled: json['canceled'] ?? 0,
      completedTransactions: json['completed_transactions'] ?? 0,
      summary: ReportSummary.fromJson(json['summary'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'on_hold': onHold,
      'canceled': canceled,
      'completed_transactions': completedTransactions,
      'summary': summary.toJson(),
    };
  }
}

class ReportSummary {
  final double totalItemAmount;
  final double itemDiscount;
  final double couponDiscount;
  final double referralDiscount;
  final double discountedAmount;
  final double vat;
  final double deliveryCharge;
  final double orderAmount;
  final double adminDiscount;
  final double restaurantDiscount;
  final double adminCommission;
  final double additionalCharge;
  final double extraPackagingAmount;
  final double commissionOnDeliveryCharge;
  final double adminNetIncome;
  final double restaurantNetIncome;

  ReportSummary({
    required this.totalItemAmount,
    required this.itemDiscount,
    required this.couponDiscount,
    required this.referralDiscount,
    required this.discountedAmount,
    required this.vat,
    required this.deliveryCharge,
    required this.orderAmount,
    required this.adminDiscount,
    required this.restaurantDiscount,
    required this.adminCommission,
    required this.additionalCharge,
    required this.extraPackagingAmount,
    required this.commissionOnDeliveryCharge,
    required this.adminNetIncome,
    required this.restaurantNetIncome,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalItemAmount: (json['total_item_amount'] ?? 0).toDouble(),
      itemDiscount: (json['item_discount'] ?? 0).toDouble(),
      couponDiscount: (json['coupon_discount'] ?? 0).toDouble(),
      referralDiscount: (json['referral_discount'] ?? 0).toDouble(),
      discountedAmount: (json['discounted_amount'] ?? 0).toDouble(),
      vat: (json['vat'] ?? 0).toDouble(),
      deliveryCharge: (json['delivery_charge'] ?? 0).toDouble(),
      orderAmount: (json['order_amount'] ?? 0).toDouble(),
      adminDiscount: (json['admin_discount'] ?? 0).toDouble(),
      restaurantDiscount: (json['restaurant_discount'] ?? 0).toDouble(),
      adminCommission: (json['admin_commission'] ?? 0).toDouble(),
      additionalCharge: (json['additional_charge'] ?? 0).toDouble(),
      extraPackagingAmount: (json['extra_packaging_amount'] ?? 0).toDouble(),
      commissionOnDeliveryCharge: (json['commission_on_delivery_charge'] ?? 0).toDouble(),
      adminNetIncome: (json['admin_net_income'] ?? 0).toDouble(),
      restaurantNetIncome: (json['restaurant_net_income'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_item_amount': totalItemAmount,
      'item_discount': itemDiscount,
      'coupon_discount': couponDiscount,
      'referral_discount': referralDiscount,
      'discounted_amount': discountedAmount,
      'vat': vat,
      'delivery_charge': deliveryCharge,
      'order_amount': orderAmount,
      'admin_discount': adminDiscount,
      'restaurant_discount': restaurantDiscount,
      'admin_commission': adminCommission,
      'additional_charge': additionalCharge,
      'extra_packaging_amount': extraPackagingAmount,
      'commission_on_delivery_charge': commissionOnDeliveryCharge,
      'admin_net_income': adminNetIncome,
      'restaurant_net_income': restaurantNetIncome,
    };
  }
}
