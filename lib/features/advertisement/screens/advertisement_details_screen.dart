import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/enums/ads_type.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/screens/create_advertisement_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/widgets/ads_item.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/widgets/confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/widgets/network_video_preview_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/extensions_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AdvertisementDetailsScreen extends StatefulWidget {
  final int id;
  final bool? fromNotification;
  const AdvertisementDetailsScreen({super.key, required this.id, this.fromNotification = false});

  @override
  State<AdvertisementDetailsScreen> createState() => _AdvertisementDetailsScreenState();
}

class _AdvertisementDetailsScreenState extends State<AdvertisementDetailsScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<AdvertisementController>().getAdvertisementDetails(id: widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(
      builder: (advertisementController) {
        return Scaffold(
          appBar: CustomAppBarWidget(
            title: "ads_details".tr,
            onBackPressed: (){
              if(widget.fromNotification!){
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }else{
                if(Navigator.canPop(context)){
                  Get.back();
                }
              }
            },
          ),
          body: Column(children: [
              Expanded(
                child: advertisementController.advertisementDetailsModel == null ? const Center(child: CircularProgressIndicator()) :

                /*advertisementController.advertisementDetailsModel != null ?
                SizedBox(height: Get.height * 0.7, child: AdvertisementDetailsEmptyScreen(advertisementId: widget.id)) :*/

                GetBuilder<AdvertisementController>(
                  builder: (advertisementController) {

                    //bool isExpired = _isAdvertisementExpired(advertisementController.advertisementDetailsModel!.endDate!);
                    String? status = advertisementController.advertisementDetailsModel!.status == 'approved' && advertisementController.advertisementDetailsModel!.active == 1 ? 'running'
                        : advertisementController.advertisementDetailsModel!.status == 'approved' && advertisementController.advertisementDetailsModel!.active == 0 ? 'expired'
                        : advertisementController.advertisementDetailsModel!.status;

                    return SingleChildScrollView(child: Column(children: [

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Expanded(
                                child: Text('${'ads_id'.tr} #${advertisementController.advertisementDetailsModel?.id}',
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.9),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: status == 'approved' ? Colors.green.withOpacity(0.2)
                                      : status == 'running' ? Colors.indigo.withOpacity(0.2)
                                      : status == 'expired' ? Theme.of(context).disabledColor.withOpacity(0.2)
                                      : status == 'denied' ? Colors.red.withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  status!.tr,
                                  style: robotoRegular.copyWith(
                                    color: status == 'approved' ? Colors.green
                                        : status == 'running' ? Colors.indigo
                                        : status == 'expired' ? Theme.of(context).disabledColor
                                        : status == 'denied' ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: Dimensions.paddingSizeDefault,
                              //       vertical: Dimensions.paddingSizeExtraSmall
                              //   ),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(50),
                              //     // color: Get.isDarkMode? Colors.grey.withOpacity(0.2): ColorResources.buttonBackgroundColorMap[advertisementController.advertisementDetailsModel?.advertisementData?.status],
                              //   ),
                              //   child: Center(
                              //     child: Text(
                              //       status!,
                              //       style: robotoMedium.copyWith(fontSize: 12, color: Theme.of(context).primaryColorLight),
                              //     ),
                              //   ),
                              // ),
                            ]),

                            const SizedBox(height:Dimensions.paddingSizeDefault),
                            Divider(height: 0.5,color: Theme.of(context).hintColor.withOpacity(0.5),),
                            const SizedBox(height:Dimensions.paddingSizeDefault),

                            AdsCard(
                              img: Images.calender,
                              title: 'ads_created'.tr,
                              subTitle: DateConverter.dateMonthYearTime(DateConverter
                                .isoUtcStringToLocalDate(advertisementController.advertisementDetailsModel?.createdAt ?? "")),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            const SizedBox(height:Dimensions.paddingSizeExtraSmall + 2),

                            AdsCard(
                              img: Images.calender,
                              title: 'duration'.tr,
                              subTitle: '${DateConverter.stringToLocalDateOnly(advertisementController.advertisementDetailsModel?.startDate ??"")} - ${DateConverter.stringToLocalDateOnly(advertisementController.advertisementDetailsModel?.endDate ??"")}',
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            const SizedBox(height:Dimensions.paddingSizeExtraSmall + 2),

                            AdsCard(
                              img: Images.adsType,
                              title: 'ads_type'.tr,
                              subTitle: "${advertisementController.advertisementDetailsModel?.addType?.tr}".toTitleCase().replaceAll('_', ' '),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              subtitleTextStyle : robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall + 1),
                            ),
                            const SizedBox(height:Dimensions.paddingSizeExtraSmall + 2),

                            AdsCard(
                              img: Images.paymentStatus,
                              title: 'payment_status'.tr,
                              subTitle: advertisementController.advertisementDetailsModel?.isPaid == 1 ? "paid".tr : "unpaid".tr,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              subtitleTextStyle : robotoMedium.copyWith(
                                color: advertisementController.advertisementDetailsModel?.isPaid == 1 ? Colors.green : Theme.of(context).colorScheme.error,
                                fontSize: Dimensions.fontSizeSmall + 1,
                              ),
                            ),

                          ],
                        ),
                      ),


                      // advertisementController.advertisementDetailsModel!.advertisementData?.additionalNote != null && advertisementController.advertisementDetailsModel!.advertisementData!.additionalNote!.isNotEmpty?
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).cardColor,
                      //     boxShadow: cardShadow,
                      //   ),
                      //   margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                      //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                      //       border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.5)),
                      //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                      //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //
                      //       const Row(),
                      //
                      //       Text(advertisementController.advertisementDetailsModel!.advertisementData?.status == 'paused' ? "# ${'paused_note'.tr}" : "# ${'cancellation_note'.tr}",
                      //         overflow: TextOverflow.ellipsis,
                      //         style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                      //             color: Theme.of(context).colorScheme.error, decoration: TextDecoration.none
                      //         ),
                      //       ),
                      //
                      //       const SizedBox(height: Dimensions.paddingSizeSmall,),
                      //
                      //       Text("${advertisementController.advertisementDetailsModel?.advertisementData?.additionalNote}",
                      //         style: ubuntuRegular.copyWith(
                      //           color: Theme.of(context).hintColor,
                      //         ),
                      //         textAlign: TextAlign.justify, maxLines: 100,
                      //       ),
                      //
                      //
                      //
                      //     ],),
                      //   ),
                      // ) : const SizedBox(),
                      //
                      // const SizedBox(height: Dimensions.paddingSizeDefault,),

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text("service_info".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                          Text("${advertisementController.advertisementDetailsModel?.title}",
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                            textAlign: TextAlign.justify,
                            maxLines: 10,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge,),


                          Text("description".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text("${advertisementController.advertisementDetailsModel?.description}",
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                            textAlign: TextAlign.justify, maxLines: 100,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          advertisementController.advertisementDetailsModel?.cancellationNote != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("denied_note".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text("${advertisementController.advertisementDetailsModel?.cancellationNote}",
                              style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                              textAlign: TextAlign.justify, maxLines: 100,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                          ]) : const SizedBox(),

                          advertisementController.advertisementDetailsModel?.pauseNote != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("pause_note_title".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text("${advertisementController.advertisementDetailsModel?.pauseNote}",
                              style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                              textAlign: TextAlign.justify, maxLines: 100,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                          ]) : const SizedBox(),

                          advertisementController.advertisementDetailsModel?.addType == AdsType.video_promotion.name ?
                          Text("video".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)): const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          advertisementController.advertisementDetailsModel?.addType == AdsType.video_promotion.name ? NetworkVideoPreviewWidget(
                            videoFile: advertisementController.advertisementDetailsModel?.videoAttachmentFullUrl ?? "",
                          ) : AspectRatio(
                            aspectRatio: 20/9,
                            child: Row(children: [


                              Expanded(flex: 2,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Text("profile_image".tr, style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis),

                                  AspectRatio(
                                    aspectRatio: 5/4.5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        child: InkWell(
                                          onTap: (){
                                            openImageDialog(context, advertisementController.advertisementDetailsModel?.profileImageFullUrl ?? '');
                                          },
                                          child: CustomImageWidget(image: "${advertisementController.advertisementDetailsModel?.profileImageFullUrl}", fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),


                              Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Text("cover_image".tr, style: robotoBold),

                                AspectRatio(
                                  aspectRatio: 20/12,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeSmall,
                                        right: Dimensions.paddingSizeDefault
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      child: InkWell(
                                        onTap: (){
                                          openImageDialog(context, advertisementController.advertisementDetailsModel?.coverImageFullUrl ?? '');
                                        },
                                        child: CustomImageWidget(image: "${advertisementController.advertisementDetailsModel?.coverImageFullUrl}",
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  ),
                                ),

                              ]))
                            ]),
                          ),


                        ]),
                      ),
                      // const SizedBox(height: 80)
                    ]),
                                );
                  }
                ),
              ),

            advertisementController.advertisementDetailsModel != null ? Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.2), blurRadius: 10)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: "edit_ads".tr,
                        fontSize: Dimensions.fontSizeDefault,
                        icon: Icons.edit,
                        onPressed: (){
                          Get.to(()=> CreateAdvertisementScreen(adsDetailsModel: advertisementController.advertisementDetailsModel));
                        },
                      ),
                    ),


                    advertisementController.advertisementDetailsModel?.status == 'pending' ?
                    const SizedBox(width: Dimensions.paddingSizeDefault): const SizedBox(),


                    advertisementController.advertisementDetailsModel?.status == 'pending' ? Expanded(
                      child: CustomButtonWidget(
                        buttonText: "delete_ads".tr,
                        color: Theme.of(context).primaryColor.withOpacity(0.07),
                        fontSize: Dimensions.fontSizeDefault,
                        onPressed: (){
                          showCustomBottomSheet(child: ConfirmationBottomSheet(
                            image: Images.deleteDialogIcon, title: "confirm_delete_dialog_title",
                            description: "confirm_delete_dialog_description", status: advertisementController.advertisementDetailsModel!.status!,
                            yesButtonPressed: () async{
                              advertisementController.deleteAdvertisement(advertisementController.advertisementDetailsModel!.id!).then((success) {
                                if(success) {
                                  Get.back();
                                }
                              });
                            },
                          ));
                          // Get.find<AdvertisementController>().resetNoteController();
                          // showCustomBottomSheet(child: ConfirmationBottomSheet(
                          //   image: Images.cancelDialogIcon, title: "cancel_dialog_title",
                          //   description: "cancel_dialog_description", status: "cancel_ads",
                          //   yesButtonPressed: () async{
                          //     if(advertisementController.noteFormKey.currentState!.validate()) {
                          //       await Get.find<AdvertisementController>().changeAdvertisementStatus(
                          //           id: advertisementController.advertisementDetailsModel?.advertisementData?.id ?? "",
                          //           status: 'canceled',
                          //           isFromDetailsPage: true
                          //       );
                          //     }
                          //   },),
                          // );
                        },
                        icon: Icons.delete_outline,
                        iconColor: Theme.of(context).textTheme.bodyMedium!.color,
                        textColor: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                      ),
                    ): const SizedBox(),
                  ],
                ),
              ),
            ): const SizedBox(),

          ]),
          // bottomSheet:
        );
      }
    );
  }

  void openImageDialog(BuildContext context, String imageUrl) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
        child: Stack(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            ),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            splashRadius: 5,
            onPressed: () => Get.back(),
            icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
          )),

        ]),
      );
    },
  );

  /*bool _isAdvertisementExpired(String endDate) {

    DateTime dateWithTime = DateConverter.isoUtcStringToLocalDateOnly(endDate);

    DateTime endDateOnly = DateTime(dateWithTime.year, dateWithTime.month, dateWithTime.day);
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if(currentDate.isAfter(endDateOnly)){
      return true;
    }
    return false;
  }*/
}

class AdvertisementDetailsEmptyScreen extends StatelessWidget {
  final int advertisementId;
  const AdvertisementDetailsEmptyScreen({super.key, required this.advertisementId});

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Image.asset(Images.emptyBox, height: Get.height * 0.1, color: Theme.of(context).primaryColor),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      Text("information_not_found".tr, style: robotoRegular),
      const SizedBox(height: Dimensions.paddingSizeLarge,),

      CustomButtonWidget(
        height: 35, width: 120, radius: Dimensions.radiusExtraLarge,
        buttonText: "go_back".tr, onPressed: () async {
        // await Get.find<AdvertisementController>().removeAdvertisementItemFromList(advertisementId, shouldUpdate: true);
        Get.back();
      },)

    ],),);
  }
}
