import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getProductList(String offset, String type, String stockType, int? categoryId);
  Future<dynamic> updateRestaurant(Restaurant restaurant, List<String> cuisines, XFile? logo, XFile? cover, String token, List<Translation> translation, String characteristics, String tags);
  Future<dynamic> addProduct(Product product, XFile? image, bool isAdd, String tags, List<int> deletedVariationIds, List<int> deletedVariationOptionIds, String nutrition, String allergicIngredients);
  Future<dynamic> getRestaurantReviewList(int? restaurantID, String? searchText);
  Future<dynamic> getProductReviewList(int? productID);
  Future<dynamic> updateProductStatus(int? productID, int status);
  Future<dynamic> updateRecommendedProductStatus(int? productID, int status);
  Future<dynamic> addSchedule(Schedules schedule);
  Future<dynamic> deleteSchedule(int? scheduleID);
  Future<dynamic> updateAnnouncement(int status, String announcement);
  Future<bool> updateReply(int reviewID, String reply);
  Future<List<String?>?> getCharacteristicSuggestionList();
  Future<bool> updateProductStock(String foodId, String itemStock, Product product, List<List<String>> variationStock);
  Future<List<String?>?> getAllergicIngredientsSuggestionList();
  Future<List<String?>?> getNutritionSuggestionList();
}