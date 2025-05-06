import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/services/addon_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class AddonController extends GetxController implements GetxService {
  final AddonServiceInterface addonServiceInterface;
  AddonController({required this.addonServiceInterface});

  List<AddOns>? _addonList;
  List<AddOns>? get addonList => _addonList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<List<int?>> getAddonList() async {
    List<AddOns>? addonList = await addonServiceInterface.getAddonList();
    List<int?> addonsIds = [];

    if(addonList != null) {
      _addonList = [];
      _addonList!.addAll(addonList);
      addonsIds.addAll(addonServiceInterface.prepareAddonIds(addonList));
    }

    update();
    return addonsIds;
  }


  Future<void> addAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonServiceInterface.addAddon(addonModel);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_added_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> updateAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess  = await addonServiceInterface.updateAddon(addonModel.toJson());
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_updated_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteAddon(int id) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonServiceInterface.deleteAddon(id);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_removed_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

}