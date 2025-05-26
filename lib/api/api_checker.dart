import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ApiChecker{
  static final Map<String, String> errors = {};

  static void checkApi(Response response) {
    if(response.body != null && response.body['errors'] != null) {
      List errorFromApi = response.body['errors'] ?? [];
      for (var error in errorFromApi) {
        if (error['code'] != null && error['message'] != null) {
          errors[error['code']] = error['message'];
        }
      }
    }
    else if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    else {
      showCustomSnackBar(response.statusText);
    }
  }
}