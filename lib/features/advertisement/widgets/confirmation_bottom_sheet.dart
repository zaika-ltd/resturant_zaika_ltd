import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String status;
  final Color? yesTestColor;
  final bool isShowNotNowButton;
  final Function() yesButtonPressed;
  final String? confirmButtonText;
  const ConfirmationBottomSheet({super.key, this.confirmButtonText, this.isShowNotNowButton = true, required this.image, required this.title, required this.description, required this.yesButtonPressed, required this.status, this.yesTestColor});

  @override
  State<ConfirmationBottomSheet> createState() => _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  // TextEditingController? noteController = TextEditingController();
  // final GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Get.find<AdvertisementController>().noteController?.text = '';
  }

  @override
  void dispose() {
    super.dispose();

    // Get.find<AdvertisementController>().noteController?.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Dimensions.radiusDefault),
          topLeft: Radius.circular(Dimensions.radiusDefault)
        )
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: GetBuilder<AdvertisementController>(
        builder: (advertisementController) {
          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [


              Image.asset(widget.image, height: 70, width: 100),
              const SizedBox(height: Dimensions.paddingSizeDefault),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(widget.title.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Text(widget.description.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              widget.status == 'cancel_ads' || widget.status == 'pause_ads' ? Form(
                key: advertisementController.noteFormKey,
                child: CustomTextFieldWidget(
                  inputType: TextInputType.text,
                  controller: advertisementController.noteController,
                  hintText: widget.status == 'cancel_ads' ? "cancelation_note".tr.replaceAll(":", "") : 'pause_note'.tr,
                  capitalization: TextCapitalization.words,
                  showLabelText: false,
                  maxLines: 3,
                  validator: (value){
                    return (value == null || value.isEmpty) ? widget.status == 'cancel_ads' ? 'enter_cancellation_note'.tr : 'enter_paused_note'.tr : null ;
                  },
                ),
              ): const SizedBox(),
              widget.status == 'cancel_ads' || widget.status == 'pause_ads' ? const SizedBox(height: Dimensions.paddingSizeLarge): const SizedBox(),

              Row(children: [
                widget.isShowNotNowButton ? Expanded(flex: 2, child: CustomButtonWidget(
                  buttonText: "not_now".tr,
                  onPressed: (){
                    if(!advertisementController.isLoading){
                      Get.back();
                    }
                  },
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  textColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
                )): const SizedBox(),


                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(flex: 2, child: advertisementController.isLoading ? const Center(child: CircularProgressIndicator()) : CustomButtonWidget(
                    buttonText: widget.confirmButtonText?.tr ?? "yes".tr,
                    onPressed: !advertisementController.isLoading? widget.yesButtonPressed : (){},
                    color: widget.yesTestColor ?? Theme.of(context).colorScheme.error
                )),



              ]),

              //SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ]),
          );
        }
      ),
    );
  }
}
