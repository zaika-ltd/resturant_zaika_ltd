import 'dart:async';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/fund_payment_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentMethod;
  final String? redirectUrl;
  final int? restaurantId;
  final bool? isSubscriptionPayment;
  final int? packageId;
  const PaymentScreen({super.key,required this.paymentMethod, this.redirectUrl, this.restaurantId, this.isSubscriptionPayment, this.packageId});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {

  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;
  double? maxCodOrderAmount;

  @override
  void initState() {
    super.initState();

    selectedUrl = widget.redirectUrl!;
    _initData();
  }

  void _initData() async {

    await Get.find<ProfileController>().trialWidgetShow(route: RouteHelper.payment);

    browser = MyInAppBrowser(redirectUrl: widget.redirectUrl, restaurantId: widget.restaurantId, isSubscriptionPayment: widget.isSubscriptionPayment, packageId: widget.packageId);

      await InAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _exitApp().then((value) => value!);
        Get.find<ProfileController>().trialWidgetShow(route: RouteHelper.payment);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBarWidget(title: 'payment'.tr, onBackPressed: () {
          _exitApp();
          Get.find<ProfileController>().trialWidgetShow(route: '');
        }),
        body: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Stack(children: [
              _isLoading ? Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              ) : const SizedBox.shrink(),
            ]),
          ),
        ),
      ),
    );
  }

  Future<bool?> _exitApp() async {
    return Get.dialog(const FundPaymentDialogWidget());
  }
}

class MyInAppBrowser extends InAppBrowser {
  final String? redirectUrl;
  final int? restaurantId;
  final bool? isSubscriptionPayment;
  final int? packageId;
  MyInAppBrowser({super.windowId, super.initialUserScripts, this.redirectUrl, this.restaurantId, this.isSubscriptionPayment, this.packageId});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _redirect(url.toString(), restaurantId, isSubscriptionPayment, packageId);
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _redirect(url.toString(), restaurantId, isSubscriptionPayment, packageId);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      // Get.dialog(PaymentFailedDialog(orderID: orderID, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount));
    }
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    if (kDebugMode) {
      print("Started at: ${resource.startTime}ms ---> duration: ${resource.duration}ms ${resource.url ?? ''}");
    }
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {print("""console output: message: ${consoleMessage.message}messageLevel: ${consoleMessage.messageLevel.toValue()}""");
    }
  }

  void _redirect(String url, int? restaurantId, bool? isSubscriptionPayment, int? packageId) {
    if(_canRedirect) {
      bool isSuccess = url.contains('${AppConstants.baseUrl}/payment-success') || url.contains('${AppConstants.baseUrl}/success?flag=success');
      bool isFailed = url.contains('${AppConstants.baseUrl}/payment-fail') || url.contains('${AppConstants.baseUrl}/success?flag=fail');
      bool isCancel = url.contains('${AppConstants.baseUrl}/payment-cancel') || url.contains('${AppConstants.baseUrl}/success?flag=cancel');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }


      if(isSuccess || isFailed || isCancel) {
        if(Get.currentRoute.contains(RouteHelper.payment)) {
          Get.back();
        }

        if(isSubscriptionPayment == true){
          Get.offAllNamed(RouteHelper.getSubscriptionSuccessRoute(status: isSuccess ? 'success' : isFailed ? 'fail' : 'cancel', fromSubscription: true, restaurantId: restaurantId, packageId: packageId));
        }else {
          Get.back();
          Get.toNamed(RouteHelper.getSuccessRoute(isSuccess ? 'success' : isFailed ? 'fail' : 'cancel',
              isWalletPayment: url.contains('${AppConstants.baseUrl}/success?flag=success') || url.contains('${AppConstants.baseUrl}/success?flag=fail') || url.contains('${AppConstants.baseUrl}/success?flag=cancel')));
        }
      }
    }
  }

}