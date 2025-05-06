import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_service_interface.dart';
import 'package:get/get.dart';

class OrderService implements OrderServiceInterface {
  final OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future<Response> getOrderDetails(int orderID) async {
    return await orderRepositoryInterface.get(orderID);
  }

  @override
  Future<List<OrderModel>?> getCurrentOrders() async {
    return await orderRepositoryInterface.getCurrentOrders();
  }

  @override
  Future<PaginatedOrderModel?> getPaginatedOrderList(int offset, String status) async {
    return await orderRepositoryInterface.getPaginatedOrderList(offset, status);
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusModel updateStatusBody, List<MultipartBody> proofAttachment) async {
    return await orderRepositoryInterface.updateOrderStatus(updateStatusBody, proofAttachment);
  }

  @override
  Future<OrderModel?> getOrderWithId(int? orderId) async {
    return await orderRepositoryInterface.getOrderWithId(orderId);
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    return await orderRepositoryInterface.getCancelReasons();
  }

  @override
  Future<bool> sendDeliveredNotification(int? orderID) async {
    return await orderRepositoryInterface.sendDeliveredNotification(orderID);
  }

  @override
  Future<void> setBluetoothAddress(String? address) async {
    await orderRepositoryInterface.setBluetoothAddress(address);
  }

  @override
  String? getBluetoothAddress() => orderRepositoryInterface.getBluetoothAddress();

  @override
  Future<bool> addDineInTableAndTokenNumber(int? orderId, String? tableNumber, String? tokenNumber) async {
    return await orderRepositoryInterface.addDineInTableAndTokenNumber(orderId, tableNumber, tokenNumber);
  }

}