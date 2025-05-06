import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/forgot_password_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/forgot_password_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';

class ForgotPasswordService implements ForgotPasswordServiceInterface {
  final ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface;
  ForgotPasswordService({required this.forgotPasswordRepositoryInterface});

  @override
  Future<ResponseModel> forgotPassword(String? email) async {
    return await forgotPasswordRepositoryInterface.forgotPassword(email);
  }

  @override
  Future<ResponseModel> verifyToken(String? email, String token) async {
    return await forgotPasswordRepositoryInterface.verifyToken(email, token);
  }

  @override
  Future<bool> changePassword(ProfileModel userInfoModel, String password) async {
    return await forgotPasswordRepositoryInterface.changePassword(userInfoModel, password);
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String? email, String password, String confirmPassword) async {
    return await forgotPasswordRepositoryInterface.resetPassword(resetToken, email, password, confirmPassword);
  }

}