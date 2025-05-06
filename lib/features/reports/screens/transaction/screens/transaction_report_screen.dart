import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/widget/transaction_report_details_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/widget/transaction_status_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({super.key});

  @override
  State<TransactionReportScreen> createState() => _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {

  final ScrollController scrollController = ScrollController();
  final completedToolTip = JustTheController();
  final onHoldToolTip = JustTheController();
  final canceledToolTip = JustTheController();

  @override
  void initState() {
    super.initState();

    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getTransactionReportList(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orderTransactions != null
          && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getTransactionReportList(
            offset: Get.find<ReportController>().offset.toString(),
            from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Scaffold(

        appBar: CustomAppBarWidget(
          title: 'transaction_report'.tr,
          menuWidget: Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: 5, bottom: 5),
            child: InkWell(
              onTap: () => reportController.showDatePicker(context, transaction: true),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: reportController.from != null && reportController.to != null ? Theme.of(context).primaryColor : null,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: reportController.from != null && reportController.to != null ? null : Border.all(color: Theme.of(context).disabledColor.withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall - 2),
                    child: Icon(Icons.calendar_today_outlined, color: reportController.from != null && reportController.to != null ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 20),
                  ),

                  reportController.from != null && reportController.to != null ? Positioned(
                    right: -3, top: -3,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).cardColor, width: 1),
                      ),
                    ),
                  ) : const SizedBox(),

                ],
              ),
            ),
          ),

        ),

        body: reportController.orderTransactions != null ? SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            SizedBox(
              height: 240,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [

                    TransactionStatusCardWidget(
                      isCompleted: true,
                      amount: reportController.completedTransactions ?? 0,
                      completedToolTip: completedToolTip,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    TransactionStatusCardWidget(
                      isOnHold: true,
                      amount: reportController.onHold ?? 0,
                      onHoldToolTip: onHoldToolTip,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    TransactionStatusCardWidget(
                      amount: reportController.canceled ?? 0,
                      canceledToolTip: canceledToolTip,
                    ),

                  ]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Text(
                  "total_transactions".tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                CustomToolTip(
                  message: 'you_are_now_viewing_one_month_of_data_to_view_more_data_click_the_filter_button'.tr,
                  preferredDirection: AxisDirection.down,
                  child: Icon(Icons.info, size: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(DateConverter.convertDateToDate(reportController.from!), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),
                const SizedBox(width: 5),

                Text('to'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(DateConverter.convertDateToDate(reportController.to!), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),

              ]),
            ),

            reportController.orderTransactions != null ? reportController.orderTransactions!.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportController.orderTransactions!.length,
              itemBuilder: (context, index) {
                return TransactionReportDetailsCardWidget(orderTransactions: reportController.orderTransactions![index]);
              },
            ) : Center(child: Padding(padding: const EdgeInsets.only(top : 200), child: Text('no_transaction_found'.tr, style: robotoMedium)))
                : const Center(child: CircularProgressIndicator()),

            reportController.isLoading ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : const SizedBox(),

          ]),
        ) : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}