import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class OrderRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getCurrentOrders();
  Future<dynamic> getPaginatedOrderList(int offset, String status);
  Future<dynamic> updateOrderStatus(UpdateStatusModel updateStatusBody, List<MultipartBody> proofAttachment);
  Future<dynamic> getOrderWithId(int? orderId);
  Future<dynamic> getCancelReasons();
  Future<dynamic> sendDeliveredNotification(int? orderID);
  Future<void> setBluetoothAddress(String? address);
  String? getBluetoothAddress();
  Future<bool> addDineInTableAndTokenNumber(int? orderId, String? tableNumber, String? tokenNumber);
}