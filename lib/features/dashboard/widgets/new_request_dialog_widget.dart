import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialogWidget extends StatefulWidget {
  const NewRequestDialogWidget({super.key});

  @override
  State<NewRequestDialogWidget> createState() => _NewRequestDialogWidgetState();
}

class _NewRequestDialogWidgetState extends State<NewRequestDialogWidget> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.mp3'));
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      audio.play(AssetSource('notification.mp3'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.notificationIn, height: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              'new_order_placed'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          CustomButtonWidget(
            height: 40,
            buttonText: 'ok'.tr,
            onPressed: () {
              _timer?.cancel();
              Get.back();
            },
          ),

        ]),
      ),
    );
  }
}