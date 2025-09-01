import 'package:stackfood_multivendor_restaurant/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';

class AppConstants {
  static const String appName = 'Zaika Restaurant';
  static const double appVersion = 8.0; ///Flutter SDK 3.27.1

  static const String baseUrl = 'https://zaika.ltd';
  static const String configUri = '/api/v1/config';
  static const String loginUri = '/api/v1/auth/vendor/login';
  static const String forgetPasswordUri = '/api/v1/auth/vendor/forgot-password';
  static const String verifyTokenUri = '/api/v1/auth/vendor/verify-token';
  static const String resetPasswordUri = '/api/v1/auth/vendor/reset-password';
  static const String tokenUri = '/api/v1/vendor/update-fcm-token';
  static const String allOrdersUri = '/api/v1/vendor/all-orders';
  static const String currentOrdersUri = '/api/v1/vendor/current-orders';
  static const String completedOrdersUri = '/api/v1/vendor/completed-orders';
  static const String orderDetailsUri = '/api/v1/vendor/order-details?order_id=';
  static const String updateOrderStatusUri = '/api/v1/vendor/update-order-status';
  static const String notificationUri = '/api/v1/vendor/notifications';
  static const String profileUri = '/api/v1/vendor/profile';
  static const String updateProfileUri = '/api/v1/vendor/update-profile';
  static const String basicCampaignUri = '/api/v1/vendor/get-basic-campaigns';
  static const String joinCampaignUri = '/api/v1/vendor/campaign-join';
  static const String leaveCampaignUri = '/api/v1/vendor/campaign-leave';
  static const String withdrawListUri = '/api/v1/vendor/get-withdraw-list';
  static const String productListUri = '/api/v1/vendor/get-products-list';
  static const String updateBankInfoUri = '/api/v1/vendor/update-bank-info';
  static const String withdrawRequestUri = '/api/v1/vendor/request-withdraw';
  static const String withdrawRequestMethodUri = '/api/v1/vendor/get-withdraw-method-list';
  static const String categoryUri = '/api/v1/categories';
  static const String subCategoryUri = '/api/v1/categories/childes/';
  static const String addonListUri = '/api/v1/vendor/addon';
  static const String addAddonUri = '/api/v1/vendor/addon/store';
  static const String updateAddonUri = '/api/v1/vendor/addon/update';
  static const String deleteAddonUri = '/api/v1/vendor/addon/delete';
  static const String attributeUri = '/api/v1/vendor/attributes';
  static const String restaurantUpdateUri = '/api/v1/vendor/update-business-setup';
  static const String addProductUri = '/api/v1/vendor/product/store';
  static const String updateProductUri = '/api/v1/vendor/product/update';
  static const String deleteProductUri = '/api/v1/vendor/product/delete';
  static const String restaurantReviewUri = '/api/v1/vendor/product/reviews';
  static const String productReviewUri = '/api/v1/products/reviews';
  static const String updateProductStatusUri = '/api/v1/vendor/product/status';
  static const String updateRestaurantStatusUri = '/api/v1/vendor/update-active-status';
  static const String searchProductListUri = '/api/v1/vendor/product/search';
  static const String placeOrderUri = '/api/v1/vendor/pos/place-order';
  static const String posOrdersUri = '/api/v1/vendor/pos/orders';
  static const String searchCustomersUri = '/api/v1/vendor/pos/customers';
  static const String dmListUri = '/api/v1/vendor/delivery-man/list';
  static const String addDmUri = '/api/v1/vendor/delivery-man/store';
  static const String updateDmUri = '/api/v1/vendor/delivery-man/update/';
  static const String deleteDmUri = '/api/v1/vendor/delivery-man/delete';
  static const String updateDmStatusUri = '/api/v1/vendor/delivery-man/status';
  static const String dmReviewUri = '/api/v1/vendor/delivery-man/preview';
  static const String addSchedule = '/api/v1/vendor/schedule/store';
  static const String deleteSchedule = '/api/v1/vendor/schedule/';
  static const String vendorRemove = '/api/v1/vendor/remove-account';
  static const String currentOrderDetailsUri = '/api/v1/vendor/order?order_id=';
  static const String zoneListUri = '/api/v1/zone/list';
  static const String searchLocationUri = '/api/v1/config/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/config/place-api-details';
  static const String zoneUri = '/api/v1/config/get-zone-id';
  static const String restaurantRegisterUri = '/api/v1/auth/vendor/register';
  static const String renewBusinessPlanUri = '/api/v1/auth/vendor/package-renew';
  static const String addCouponUri = '/api/v1/vendor/coupon-store';
  static const String couponListUri = '/api/v1/vendor/coupon-list';
  static const String couponChangeStatusUri = '/api/v1/vendor/coupon-status';
  static const String couponDeleteUri = '/api/v1/vendor/coupon-delete';
  static const String couponUpdateUri = '/api/v1/vendor/coupon-update';
  static const String expanseListUri = '/api/v1/vendor/get-expense';
  static const String orderCancellationUri = '/api/v1/customer/order/cancellation-reasons';
  static const String cuisineUri = '/api/v1/cuisine';
  static const String updateProductRecommendedUri = '/api/v1/vendor/product/recommended';
  static const String geocodeUri = '/api/v1/config/geocode-api';
  static const String couponDetailsUri = '/api/v1/vendor/coupon/view-without-translate';
  static const String productDetailsUri = '/api/v1/vendor/product/details';
  static const String deliveredOrderNotificationUri = '/api/v1/vendor/send-order-otp';
  static const String businessPlanPaymentUri = '/api/v1/auth/vendor/subscription/payment/api';
  static const String announcementUri = '/api/v1/vendor/update-announcment';
  static const String deliverymanListUri = '/api/v1/vendor/delivery-man/get-delivery-man-list';
  static const String assignDeliverymanUri = '/api/v1/vendor/delivery-man/assign-deliveryman';
  static const String transactionReportUri = '/api/v1/vendor/get-transaction-report';
  static const String transactionReportDateWiseUri = '/api/v1/vendor/get-transaction-report-date-wise';

  static const String orderReportUri = '/api/v1/vendor/get-order-report';
  static const String campaignReportUri = '/api/v1/vendor/get-campaign-order-report';
  static const String foodReportUri = '/api/v1/vendor/get-food-wise-report';
  static const String makeCollectedCashPaymentUri = '/api/v1/vendor/make-collected-cash-payment';
  static const String makeWalletAdjustmentUri = '/api/v1/vendor/make-wallet-adjustment';
  static const String walletPaymentListUri = '/api/v1/vendor/wallet-payment-list';
  static const String addWithdrawMethodUri = '/api/v1/vendor/withdraw-method/store';
  static const String disbursementMethodListUri = '/api/v1/vendor/withdraw-method/list';
  static const String makeDefaultDisbursementMethodUri = '/api/v1/vendor/withdraw-method/make-default';
  static const String deleteDisbursementMethodUri = '/api/v1/vendor/withdraw-method/delete';
  static const String getDisbursementReportUri = '/api/v1/vendor/get-disbursement-report';
  static const String updateReplyUri = '/api/v1/vendor/product/reply-update';
  static const String getCharacteristicSuggestion = '/api/v1/vendor/get-characteristic-suggestion';
  static const String productUpdateStock = '/api/v1/vendor/product/update-stock';
  static const String getTransactionStatement = '/api/v1/vendor/generate-transaction-statement';
  static const String getNutritionSuggestionUri = '/api/v1/food/get-nutrition-name-list';
  static const String getAllergicIngredientsSuggestionUri = '/api/v1/food/get-allergy-name-list';
  static const String addDineInTableAndTokenUri = '/api/v1/vendor/add-dine-in-table-number';

  ///Subscription
  static const String businessPlanUri = '/api/v1/vendor/business_plan';
  static const String restaurantPackagesUri = '/api/v1/vendor/package-view';
  static const String subscriptionTransactionUri = '/api/v1/vendor/subscription-transaction';
  static const String cancelSubscriptionUri = '/api/v1/vendor/cancel-subscription';
  static const String checkProductLimitsUri = '/api/v1/vendor/check-product-limits';


  ///Chatting
  static const String getConversationListUri = '/api/v1/vendor/message/list';
  static const String getMessageListUri = '/api/v1/vendor/message/details';
  static const String sendMessageUri = '/api/v1/vendor/message/send';
  static const String searchConversationUri = '/api/v1/vendor/message/search-list';

  ///Advertisement
  static const String getAdvertisementListUri = '/api/v1/vendor/advertisement';
  static const String advertisementDetailsUri = '/api/v1/vendor/advertisement/details';
  static const String addAdvertisementUri = '/api/v1/vendor/advertisement/store';
  static const String updateAdvertisementUri = '/api/v1/vendor/advertisement/update';
  static const String deleteAdvertisementUri = '/api/v1/vendor/advertisement/delete/';
  static const String changeAdvertisementStatusUri = '/api/v1/vendor/advertisement/status';
  static const String copyAddAdvertisementUri = '/api/v1/vendor/advertisement/copy-add-post';



  // Shared Key
  static const String theme = 'theme';
  static const String intro = 'intro';
  static const String token = 'multivendor_restaurant_token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cacheCountryCode = 'cache_country_code';
  static const String cacheLanguageCode = 'cache_language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String notification = 'notification';
  static const String notificationCount = 'notification_count';
  static const String searchHistory = 'search_history';
  static const String topic = 'all_zone_restaurant';
  static const String zoneTopic = 'zone_topic';
  static const String localizationKey = 'X-localization';
  static const String bluetoothMacAddress = 'bluetooth_mac_address';
  static const String maintenanceModeTopic = 'maintenance_mode_restaurant_app';
  static const String isRestaurantRegister = 'stackfood_restaurant_registration';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    // LanguageModel(imageUrl: Images.hindi, languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
    // LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
    // LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
    // LanguageModel(imageUrl: Images.bengali, languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
  ];

  static const double maxLimitOfFileSentINConversation = 25;
  static const double maxLimitOfTotalFileSent = 5;
  static const double maxSizeOfASingleFile = 10;
  static const double maxImageSend = 10;
  static const double limitOfPickedVideoSizeInMB = 50;
}
