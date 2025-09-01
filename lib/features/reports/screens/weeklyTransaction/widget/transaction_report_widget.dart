import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_date_wise.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/title_with_amount_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../../../common/widgets/custom_button_widget.dart';
class TransactionReportDetail extends StatefulWidget {
  final ReportSummary orderTransactions;

  const TransactionReportDetail({super.key, required this.orderTransactions});

  @override
  State<TransactionReportDetail> createState() => _TransactionReportDetailState();
}

class _TransactionReportDetailState extends State<TransactionReportDetail> {

  final GlobalKey _globalKey = GlobalKey();
  bool _isLoading = false;
  Future<void> _captureAndExportAsPdf() async {
    // 1. Request Permissions
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar(
        'permission_denied'.tr,
        'please_grant_storage_permission_to_export_the_report'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Find the RenderObject from the GlobalKey
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // 3. Render the widget to an image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Use a higher pixelRatio for better quality
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();

      // 4. Create a PDF document
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);

      // 5. Add the image to a page in the PDF
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ));

      // 6. Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/TransactionReport_${DateTime.now().millisecondsSinceEpoch}.pdf");

      // 7. Write the PDF to a file
      await file.writeAsBytes(await pdf.save());

      // 8. Open the file
      OpenFile.open(file.path);

      Get.snackbar(
        'success'.tr,
        'report_exported_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      debugPrint("Error exporting PDF: $e");
      Get.snackbar(
        'error'.tr,
        'failed_to_export_report'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return  RepaintBoundary(
        key: _globalKey,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
              topRight: Radius.circular(Dimensions.radiusExtraLarge),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              child: Column(children: [

                // const SizedBox(height: Dimensions.paddingSizeLarge),

                // Container(
                //   height: 5, width: 50,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).disabledColor.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                //   ),
                // ),
                // const SizedBox(height: Dimensions.paddingSizeDefault),
                //
                // Padding(
                //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                //   child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //
                //     Expanded(
                //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //         Text('transaction_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.6))),
                //         const SizedBox(height: Dimensions.paddingSizeDefault),
                //
                //
                //
                //       ]),
                //     ),
                //     const SizedBox(width: Dimensions.paddingSizeLarge),
                //
                //     // ExportButton(
                //     //   onTap: reportController.isLoading ? null : () => reportController.getTransactionReportStatement(orderTransactions.orderId!),
                //     //   isLoading: reportController.isLoading,
                //     // ),
                //
                //   ]),
                // ),

              ]),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [

                    TitleWithAmountWidget(title: 'total_food_amount'.tr, amount: widget.orderTransactions.totalItemAmount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'food_discount'.tr, amount: widget.orderTransactions.itemDiscount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'coupon_discount'.tr, amount: widget.orderTransactions.couponDiscount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'total_discount'.tr, amount: widget.orderTransactions.discountedAmount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'vat_tax'.tr, amount: widget.orderTransactions.vat ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'delivery_charge'.tr, amount: widget.orderTransactions.deliveryCharge ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'order_amount'.tr, amount: widget.orderTransactions.orderAmount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'admin_discount'.tr, amount: widget.orderTransactions.adminDiscount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'restaurant_discount'.tr, amount: widget.orderTransactions.restaurantDiscount ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'admin_commission'.tr, amount: widget.orderTransactions.adminCommission ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    TitleWithAmountWidget(title: 'additional_charge'.tr, amount: widget.orderTransactions.additionalCharge ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'commission_on_delivery_charge'.tr, amount: widget.orderTransactions.commissionOnDeliveryCharge ?? 0),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    TitleWithAmountWidget(title: 'restaurant_net_income'.tr, amount: widget.orderTransactions.restaurantNetIncome ?? 0),

                  ]),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            //   child:_isLoading
            //       ? const Center(child: CircularProgressIndicator())
            //       : CustomButtonWidget(
            //     buttonText: 'export_as_pdf'.tr,
            //     onPressed: _captureAndExportAsPdf,
            //   ),
            // ),
          ]),
        ),
      );
    });
  }
}