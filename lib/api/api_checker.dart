import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ApiChecker {
  static final Map<String, String> errors = {};

  static void checkApi(Response response) {
    if (response.body != null && response.body['errors'] != null) {
      List errorFromApi = response.body['errors'] ?? [];
      for (var error in errorFromApi) {
        if (error['code'] != null && error['message'] != null) {
          errors[error['code']] = error['message'];
        }
      }
    } else if (response.statusCode == 401) {
      debugPrint('logout user session expired');
      // Get.dialog(
      //     ConfirmationDialogWidget(
      //         icon: Images.support,
      //         description: 'your_session_is_expired'.tr,
      //         isLogOut: true,
      //         onYesPressed: () async {
      //           Get.find<AuthController>().clearSharedData();
      //           await Get.find<ProfileController>()
      //               .trialWidgetShow(route: RouteHelper.payment);
      //           Get.offAllNamed(RouteHelper.getSignInRoute());
      //         }),
      //     useSafeArea: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      showCustomSnackBar(response.statusText);
    }
  }
}
