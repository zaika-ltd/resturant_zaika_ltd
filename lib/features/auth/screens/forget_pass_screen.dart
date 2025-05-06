import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emailFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'forgot_password'.tr),

      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Flexible(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeOverExtraLarge,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                const CustomAssetImageWidget(
                  image: Images.changePasswordBgImage,
                  height: 145, width: 160,
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(
                  width: context.width * 0.75,
                  child: Text('do_not_worry_give_your_registration_email_address_and_get_otp_to_update_your_password'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5)), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 35),

                CustomTextFieldWidget(
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                  focusNode: _emailFocus,
                  hintText: 'enter_email'.tr,
                  labelText: 'email'.tr,
                  prefixIcon: Icons.email,
                  onChanged: (String text) => setState(() {}),
                ),

              ]),
            ),
          ),
        ),

        GetBuilder<ForgotPasswordController>(builder: (forgotPasswordController) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: !forgotPasswordController.isForgotLoading ? CustomButtonWidget(
              buttonText: 'get_otp'.tr,
              color: _emailController.text.trim().isEmpty ? Theme.of(context).disabledColor.withOpacity(0.7) : Theme.of(context).primaryColor,
              onPressed: () => _emailController.text.trim().isNotEmpty ? _forgetPass() : null,
            ) : const Center(child: CircularProgressIndicator()),
          );
        }),

      ]),
    );
  }

  void _forgetPass() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else {
      Get.find<ForgotPasswordController>().forgotPassword(email).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(email));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

}