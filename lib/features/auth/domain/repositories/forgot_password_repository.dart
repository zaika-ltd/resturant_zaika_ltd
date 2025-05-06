import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/forgot_password_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordRepository implements ForgotPasswordRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ForgotPasswordRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ResponseModel> forgotPassword(String? email) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.forgetPasswordUri, {"email": email});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> verifyToken(String? email, String token) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.verifyTokenUri, {"email": email, "reset_token": token});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<bool> changePassword(ProfileModel userInfoModel, String password) async {
    Response response = await apiClient.postData(AppConstants.updateProfileUri, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'phone': userInfoModel.phone, 'password': password, 'token': _getUserToken()});
    return (response.statusCode == 200);
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String? email, String password, String confirmPassword) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.resetPasswordUri,
      {"_method": "put", "email": email, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword});
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}