import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_toast.dart';
// Future<void> capturedImageToPdf({
//   Uint8List? capturedImage,
//   required String businessName,
//   required String orderId,
// }) async {
//   if (capturedImage == null) return;
//
//   final pdf = pw.Document();
//   final image = pw.MemoryImage(capturedImage);
//
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Center(child: pw.Image(image)),
//     ),
//   );
//
//   Directory output;
//
//   if (Platform.isAndroid) {
//     // Ask for basic permission only if needed
//     final status = await Permission.storage.request();
//     debugPrint("Permission Status $status");
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(Get.context!).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           content: CustomToast(
//             text: 'Storage permission denie',
//             isError: true,
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     // Use app-specific directory (safe)
//     output = (await getExternalStorageDirectory())!;
//   } else {
//     output = await getApplicationDocumentsDirectory();
//   }
//  output = await PdfDownloadHelper.getProjectDirectory(businessName);
//   final file = File("${output.path}/${'invoice'.tr}-$orderId.pdf");
//  await file.writeAsBytes(await pdf.save());
//   ScaffoldMessenger.of(Get.context!).showSnackBar(
//     SnackBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       content: CustomToast(
//         text: '${'pdf_saved_at'.tr} ${file.path.replaceAll('/storage/emulated/0/', '')}',
//         isError: false,
//       ),
//       duration: const Duration(seconds: 2),
//     ),
//   );
// }
//

import 'package:file_saver/file_saver.dart'; // Import the package
// Make sure you have your other necessary imports like flutter/material.dart, get/get.dart, etc.

Future<void> capturedImageToPdf({
  Uint8List? capturedImage,
  required String businessName, // Kept for potential use in filename, though orderId is better
  required String orderId,
}) async {
  if (capturedImage == null) {
    print('❌ Error: Captured image data is null.');
    return;
  }

  // --- 1. Create the PDF in memory ---
  final pdf = pw.Document();
  final image = pw.MemoryImage(capturedImage);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(child: pw.Image(image)),
    ),
  );

  // --- 2. Save the PDF using FileSaver ---
  try {
    // Generate the PDF bytes
    final Uint8List pdfBytes = await pdf.save();

    // Use FileSaver to save the file. This handles all permissions automatically.
    final String? filePath = await FileSaver.instance.saveAs(
      name: '${'invoice'.tr}-$orderId', // Filename for the user
      bytes: pdfBytes,
      fileExtension: 'pdf', // File extension
      mimeType: MimeType.pdf, // The type of file
    );

    // --- 3. Show a user-friendly confirmation message ---
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomToast(
          text: filePath != null
              ? '${'pdf_saved_successfully'.tr}'
              : 'file_saving_cancelled'.tr,
          isError: false,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  } catch (e) {
    // Handle any errors that might occur during the saving process
    print('❌ Error saving PDF: $e');
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomToast(
          text: 'failed_to_save_pdf'.tr,
          isError: true,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}