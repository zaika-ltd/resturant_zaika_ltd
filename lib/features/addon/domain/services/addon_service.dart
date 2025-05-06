import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/services/addon_service_interface.dart';

class AddonService implements AddonServiceInterface {
  final AddonRepositoryInterface addonRepoInterface;
  AddonService({required this.addonRepoInterface});

  @override
  Future<List<AddOns>?> getAddonList() async{
    return await addonRepoInterface.getList();
  }

  @override
  Future<bool> addAddon(AddOns addonModel) async{
    return await addonRepoInterface.add(addonModel);
  }

  @override
  Future<bool> updateAddon(Map<String, dynamic> body) async{
    return await addonRepoInterface.update(body);
  }

  @override
  Future<bool> deleteAddon(int id) async{
    return await addonRepoInterface.delete(id: id);
  }

  @override
  List<int?> prepareAddonIds(List<AddOns> addonList) {
    List<int?> addonsIds = [];
    for (var addon in addonList) {
      addonsIds.add(addon.id);
    }
    return addonsIds;
  }

}