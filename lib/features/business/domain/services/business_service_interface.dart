import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_body.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';

abstract class BusinessServiceInterface{
  Future<PackageModel?> getPackageList();
  Future<String> processesBusinessPlan(String businessPlanStatus, int paymentIndex, int restaurantId, String? digitalPaymentName, int? selectedPackageId);
  Future<String> setUpBusinessPlan(BusinessPlanBody businessPlanBody, String? digitalPaymentName, String businessPlanStatus, int restaurantId, int? packageId);
}