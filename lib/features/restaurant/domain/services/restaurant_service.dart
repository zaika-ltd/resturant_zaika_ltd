import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantService implements RestaurantServiceInterface {
  final RestaurantRepositoryInterface restaurantRepositoryInterface;
  RestaurantService({required this.restaurantRepositoryInterface});

  @override
  Future<CuisineModel?> getCuisineList() async {
    return await restaurantRepositoryInterface.getList();
  }

  @override
  Future<ProductModel?> getProductList(String offset, String type, String stockType, int? categoryId) async {
    return await restaurantRepositoryInterface.getProductList(offset, type, stockType, categoryId);
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant, List<String> cuisines, XFile? logo, XFile? cover, String token, List<Translation> translation, String characteristics, String tags) async {
    return await restaurantRepositoryInterface.updateRestaurant(restaurant, cuisines, logo, cover, token, translation, characteristics, tags);
  }

  @override
  Future<bool> addProduct(Product product, XFile? image, bool isAdd, String tags, List<int> deletedVariationIds, List<int> deletedVariationOptionIds, String nutrition, String allergicIngredients) async {
    return await restaurantRepositoryInterface.addProduct(product, image, isAdd, tags, deletedVariationIds, deletedVariationOptionIds, nutrition, allergicIngredients);
  }

  @override
  Future<bool> deleteProduct(int productID) async {
    return await restaurantRepositoryInterface.delete(id: productID);
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(int? restaurantID, String? searchText) async {
    return await restaurantRepositoryInterface.getRestaurantReviewList(restaurantID, searchText);
  }

  @override
  Future<List<ReviewModel>?> getProductReviewList(int? productID) async {
    return await restaurantRepositoryInterface.getProductReviewList(productID);
  }

  @override
  Future<bool> updateProductStatus(int? productID, int status) async {
    return await restaurantRepositoryInterface.updateProductStatus(productID, status);
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    return await restaurantRepositoryInterface.updateRecommendedProductStatus(productID, status);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    return await restaurantRepositoryInterface.addSchedule(schedule);
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    return await restaurantRepositoryInterface.deleteSchedule(scheduleID);
  }

  @override
  Future<Product?> getProductDetails(int productId) async {
    return await restaurantRepositoryInterface.get(productId);
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    return await restaurantRepositoryInterface.updateAnnouncement(status, announcement);
  }

  @override
  Future<bool> updateReply(int reviewID, String reply) async {
    return await restaurantRepositoryInterface.updateReply(reviewID, reply);
  }

  @override
  Future<List<String?>?> getCharacteristicSuggestionList() async {
    return await restaurantRepositoryInterface.getCharacteristicSuggestionList();
  }

  @override
  Future<bool> updateProductStock(String foodId, String itemStock, Product product, List<List<String>> variationStock) async {
    return await restaurantRepositoryInterface.updateProductStock(foodId, itemStock, product, variationStock);
  }

  @override
  Future<List<String?>?> getNutritionSuggestionList() async {
    return await restaurantRepositoryInterface.getNutritionSuggestionList();
  }

  @override
  Future<List<String?>?> getAllergicIngredientsSuggestionList() async {
    return await restaurantRepositoryInterface.getAllergicIngredientsSuggestionList();
  }

}