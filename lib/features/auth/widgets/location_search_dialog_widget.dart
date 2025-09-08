import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class LocationSearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialogWidget({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: SizedBox(
            width: context.width,
            child: TypeAheadField<PredictionModel>(
              controller: controller,
              debounceDuration: const Duration(milliseconds: 300),
              hideOnEmpty: true,
              hideOnLoading: false,
              loadingBuilder: (context) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
              emptyBuilder: (context) => ListTile(
                title: Text('no_result_found'.tr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).disabledColor)),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.trim().isEmpty) return <PredictionModel>[];
                return await Get.find<LocationController>()
                    .searchLocation(context, pattern);
              },
              itemBuilder: (context, PredictionModel suggestion) {
                final desc = suggestion.description ?? '';
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          desc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (PredictionModel suggestion) async {
                try {
                  final placeId = suggestion.placeId;
                  final description = suggestion.description;
                  if (placeId == null) return;
                  Position position = await Get.find<LocationController>()
                      .setSuggestedLocation(
                          placeId, description, mapController);
                  Get.back(result: position);
                } catch (e) {
                  debugPrint('Location suggestion selection failed: $e');
                }
              },
              builder: (context, TextEditingController textCtrl,
                  FocusNode focusNode) {
                return TextField(
                  controller: textCtrl,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      Get.find<LocationController>()
                          .searchLocation(context, value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'search_location'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle:
                        Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).disabledColor,
                            ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                );
              },
            )),
      ),
    );
  }
}
