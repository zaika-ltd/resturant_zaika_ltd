import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class ReportRepository implements ReportRepositoryInterface {
  final ApiClient apiClient;
  ReportRepository({required this.apiClient});

  @override
  Future<TransactionReportModel?> getTransactionReportList({required int offset, required String? from, required String? to}) async {
    TransactionReportModel? transactionReportModel;
    Response response = await apiClient.getData('${AppConstants.transactionReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      transactionReportModel = TransactionReportModel.fromJson(response.body);
    }
    return transactionReportModel;
  }

  @override
  Future<OrderReportModel?> getOrderReportList({required int offset, required String? from, required String? to}) async {
    OrderReportModel? orderReportModel;
    Response response = await apiClient.getData('${AppConstants.orderReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      orderReportModel = OrderReportModel.fromJson(response.body);
    }
    return orderReportModel;
  }

  @override
  Future<OrderReportModel?> getCampaignReportList({required int offset, required String? from, required String? to}) async {
    OrderReportModel? campaignReportModel;
    Response response = await apiClient.getData('${AppConstants.campaignReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      campaignReportModel = OrderReportModel.fromJson(response.body);
    }
    return campaignReportModel;
  }

  @override
  Future<FoodReportModel?> getFoodReportList({required int offset, required String? from, required String? to}) async {
    FoodReportModel? foodReportModel;
    Response response = await apiClient.getData('${AppConstants.foodReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      foodReportModel = FoodReportModel.fromJson(response.body);
    }
    return foodReportModel;
  }

  @override
  Future<Response> getTransactionReportStatement({required int orderId}) async {
    Response response = await apiClient.getData('${AppConstants.getTransactionStatement}?order_id=$orderId');
    return response;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}