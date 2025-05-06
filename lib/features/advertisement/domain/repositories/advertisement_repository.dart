import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/domain/repositories/advertisement_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/models/ads_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/models/advertisement_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class AdvertisementRepository implements AdvertisementRepositoryInterface {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future<Response> submitNewAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile) async {
    return await apiClient.postMultipartData(
      AppConstants.addAdvertisementUri,
      body, selectedFile , [],
    );
  }

  @override
  Future<Response> copyAddAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile) async {
    return await apiClient.postMultipartData(
      AppConstants.copyAddAdvertisementUri,
      body, selectedFile , [],
    );
  }

  @override
  Future delete({int? id}) async {
    return await _deleteAdvertisement(id: id!);
  }

  Future<bool> _deleteAdvertisement({required int id}) async {
    Response response = await apiClient.deleteData("${AppConstants.deleteAdvertisementUri}$id");
    return response.statusCode == 200;
  }

  @override
  Future<AdsDetailsModel?> get(int id) async {
    return await _getAdvertisementDetails(id: id);
  }

  Future<AdsDetailsModel?> _getAdvertisementDetails ({required int id}) async {
    AdsDetailsModel? adsDetailsModel;
    Response response = await apiClient.getData("${AppConstants.advertisementDetailsUri}/$id");
    if(response.statusCode == 200) {
      adsDetailsModel = AdsDetailsModel.fromJson(response.body);
    }
    return adsDetailsModel;
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future<AdvertisementModel?> getAdvertisementList(String offset, String type) async {
    AdvertisementModel? advertisementModel;
    Response response = await apiClient.getData('${AppConstants.getAdvertisementListUri}?offset=$offset&limit=10&ads_type=$type');
    if(response.statusCode == 200) {
      advertisementModel = AdvertisementModel.fromJson(response.body);
    }
    return advertisementModel;
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future<Response> editAdvertisement({required String id, required Map<String, String> body, List<MultipartBody>? selectedFile}) async {
    return await apiClient.postMultipartData(
      "${AppConstants.updateAdvertisementUri}/$id",
      body,
      selectedFile! , [],
    );
  }

  @override
  Future<bool> changeAdvertisementStatus({required String note, required String status, required int id}) async{
    Response response = await apiClient.postData(AppConstants.changeAdvertisementStatusUri, {
      '_method': 'PUT',
      'id': '$id',
      'status': status,
      'pause_note': note,
    });
    if(response.statusCode == 200) {
     showCustomSnackBar(response.body['message'], isError: false);
    }
    return response.statusCode == 200;
  }


}