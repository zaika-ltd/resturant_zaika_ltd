import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

// Your other existing imports
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/widget/transaction_status_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/weeklyTransaction/widget/transaction_report_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';

class WeeklyTransactionReportScreen extends StatefulWidget {
  const WeeklyTransactionReportScreen({super.key});

  @override
  State<WeeklyTransactionReportScreen> createState() =>
      _WeeklyTransactionReportScreenState();
}

class _WeeklyTransactionReportScreenState
    extends State<WeeklyTransactionReportScreen> {
  final GlobalKey _reportKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final completedToolTip = JustTheController();
  final onHoldToolTip = JustTheController();
  final canceledToolTip = JustTheController();

  @override
  void initState() {
    super.initState();
    // Your initState logic remains the same
    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getTransactionReportDateWise(
      from: Get.find<ReportController>().from,
      to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<ReportController>().orderTransactions != null &&
          !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>()
              .setOffset(Get.find<ReportController>().offset + 1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getTransactionReportList(
            offset: Get.find<ReportController>().offset.toString(),
            from: Get.find<ReportController>().from,
            to: Get.find<ReportController>().to,
          );
        }
      }
    });
  }

  /// Universal function to generate and save/share the PDF
  Future<void> _generateAndExportPdf() async {
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      // Step 1: Capture widget and create PDF (same for both platforms)
      RenderRepaintBoundary boundary = _reportKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);
      pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage))));
      Uint8List pdfBytes = await pdf.save();
      String reportName =
          'TransactionReport_${DateTime.now().millisecondsSinceEpoch}';

      Get.back(); // Close loading dialog before showing save/share dialog

      // Step 2: Check the platform and use the appropriate method
      if (Platform.isIOS) {
        // --- iOS Logic: Use Share Sheet ---
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/$reportName.pdf').create();
        await file.writeAsBytes(pdfBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Transaction Report',
        );
      } else {
        // --- Android Logic: Use File Saver ---
        final filePath = await FileSaver.instance.saveAs(
          name: reportName,
          bytes: pdfBytes,
          fileExtension: 'pdf',
          mimeType: MimeType.pdf,
        );

        if (filePath != null && filePath.isNotEmpty) {
          Get.snackbar(
              'Download Complete', 'The report was saved successfully.',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Save Cancelled', 'The file was not saved.',
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar('Error', 'Failed to export PDF: $e');
      print('PDF Export Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Weekly Transaction Report',
          menuWidget: Padding(
            padding: const EdgeInsets.only(
                right: Dimensions.paddingSizeSmall, top: 5, bottom: 5),
            child: InkWell(
              onTap: () => reportController.showDatePicker(context,
                  transactionDateWise: true),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: reportController.from != null &&
                              reportController.to != null
                          ? Theme.of(context).primaryColor
                          : null,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      border: reportController.from != null &&
                              reportController.to != null
                          ? null
                          : Border.all(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withValues(alpha: 0.4)),
                    ),
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeSmall - 2),
                    child: Icon(Icons.calendar_today_outlined,
                        color: reportController.from != null &&
                                reportController.to != null
                            ? Theme.of(context).cardColor
                            : Theme.of(context).disabledColor,
                        size: 20),
                  ),
                  reportController.from != null && reportController.to != null
                      ? Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context).cardColor, width: 1),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        body: reportController.reportSummary != null
            ? SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 240,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              TransactionStatusCardWidget(
                                isCompleted: true,
                                amount: (reportController
                                            .completedTransactionsDateWise ??
                                        0)
                                    .toDouble(),
                                completedToolTip: completedToolTip,
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                              TransactionStatusCardWidget(
                                isOnHold: true,
                                amount: (reportController.onHoldDateWise ?? 0)
                                    .toDouble(),
                                onHoldToolTip: onHoldToolTip,
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                              TransactionStatusCardWidget(
                                amount: (reportController.canceledDateWise ?? 0)
                                    .toDouble(),
                                canceledToolTip: canceledToolTip,
                              ),
                            ]),
                          ),
                        ),
                      ),
                      RepaintBoundary(
                        key: _reportKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "total_transactions".tr,
                                      style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    CustomToolTip(
                                      message:
                                          'you_are_now_viewing_one_month_of_data_to_view_more_data_click_the_filter_button'
                                              .tr,
                                      preferredDirection: AxisDirection.down,
                                      child: Icon(Icons.info,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Text(
                                          DateConverter.convertDateToDate(
                                              reportController.from!),
                                          style: robotoBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                    ),
                                    const SizedBox(width: 5),
                                    Text('to'.tr,
                                        style: robotoRegular.copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                    const SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Text(
                                          DateConverter.convertDateToDate(
                                              reportController.to!),
                                          style: robotoBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                    ),
                                  ]),
                            ),
                            reportController.reportSummary != null
                                ? TransactionReportDetail(
                                    orderTransactions:
                                        reportController.reportSummary!)
                                : Center(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 200),
                                        child: Text('no_transaction_found'.tr,
                                            style: robotoMedium))),
                          ],
                        ),
                      ),
                      reportController.reportSummary != null
                          ? Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeLarge),
                              child: CustomButtonWidget(
                                buttonText: 'export'.tr,
                                onPressed: _generateAndExportPdf,
                              ),
                            )
                          : SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      reportController.isLoading
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                            ))
                          : const SizedBox(),
                    ]),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
