import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class OrderButtonWidget extends StatelessWidget {
  final String title;
  final int index;
  final OrderController orderController;
  final bool fromHistory;
  const OrderButtonWidget({super.key, required this.title, required this.index, required this.orderController, required this.fromHistory});

  @override
  Widget build(BuildContext context) {

    int selectedIndex;
    int length = 0;

    if(fromHistory) {
      selectedIndex = orderController.historyIndex;
      length = 0;
    }else {
      selectedIndex = orderController.orderIndex;
      length = orderController.runningOrders![index].orderList.length;
    }

    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => fromHistory ? orderController.setHistoryIndex(index) : orderController.setOrderIndex(index),
      child: Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.3),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                title,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),

              !fromHistory ? Container(
                margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: isSelected ? Theme.of(context).cardColor.withOpacity(0.2) : Theme.of(context).cardColor.withOpacity(0.4),
                ),
                child: Text(
                  length.toString(),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ) : const SizedBox(),
            ],
          ),
        ),

        const SizedBox(width: Dimensions.paddingSizeSmall),

        // (index != titleLength-1 && index != selectedIndex && index != selectedIndex-1)
        //     ? const SizedBox(width: Dimensions.paddingSizeExtraSmall) : const SizedBox(),

      ]),
    );
  }
}