import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DateConverter {

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String estimatedOnlyDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateTimeNewFormat(String dateTime) {
    return DateFormat('dd/MM/yyyy, ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String isoStringToLocalDateTimeOnly(String dateTime) {
    return DateFormat('dd MMM yyyy | HH:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringForDisbursement(String time) {
    var newTime = '${time.substring(0,10)} ${time.substring(11,23)}';
    return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(newTime));

    // return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertStringTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static String convertTimeToTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static DateTime convertTimeToDateTime(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static String convertDateToDate(String date) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(date));
  }

  static String stringToLocalDateDayOnly(String dateTime) {
    return DateFormat('dd').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String stringToLocalDateMonthAndYearOnly(String dateTime) {
    return DateFormat('MMM yy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }


  static String dateTimeStringToMonthAndTime(String dateTime) {
    return DateFormat('dd MMM yyyy HH:mm').format(dateTimeStringToDate(dateTime));
  }

  static String dateTimeForCoupon(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static bool isAvailable(String? start, String? end, {DateTime? time, bool isoTime = false}) {
    DateTime currentTime;
    if(time != null) {
      currentTime = time;
    }else {
      currentTime = Get.find<SplashController>().currentTime;
    }
    DateTime start0 = start != null ? isoTime ? isoStringToLocalDate(start) : DateFormat('HH:mm').parse(start) : DateTime(currentTime.year);
    DateTime end0 = end != null ? isoTime ? isoStringToLocalDate(end) : DateFormat('HH:mm').parse(end) : DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 59);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);
    if(endTime.isBefore(startTime)) {
      if(currentTime.isBefore(startTime) && currentTime.isBefore(endTime)){
        startTime = startTime.add(const Duration(days: -1));
      }else {
        endTime = endTime.add(const Duration(days: 1));
      }
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String _timeFormatter() {
    return Get.find<SplashController>().configModel!.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static int differenceInMinute(String? deliveryTime, String? orderTime, int? processingTime, String? scheduleAt) {
    int minTime = processingTime ?? 0;
    if(deliveryTime != null && deliveryTime.isNotEmpty && processingTime == null) {
      try {
        List<String> timeList = deliveryTime.split('-');
        minTime = int.parse(timeList[0]);
      }catch(_) {}
    }
    DateTime deliveryTime0 = dateTimeStringToDate(scheduleAt ?? orderTime!).add(Duration(minutes: minTime));
    return deliveryTime0.difference(DateTime.now()).inMinutes;
  }

  static bool isBeforeTime(String? dateTime) {
    if(dateTime == null) {
      return false;
    }
    DateTime scheduleTime = dateTimeStringToDate(dateTime);
    return scheduleTime.isBefore(DateTime.now());
  }

  static String convertDateTimeToDate(DateTime time) {
    return DateFormat(_timeFormatter()).format(time);
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('MMM d, yyyy ').format(dateTime.toLocal());
  }

  static String localDateToIsoStringAM(DateTime dateTime) {
    return DateFormat('dd MMM, yyyy, ${_timeFormatter()}').format(dateTime.toLocal());
  }

  static DateTime isoUtcStringToLocalTimeOnly(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalDateAndTime(String dateTime) {
    return DateFormat('dd MMM yyyy \'at\' ${_timeFormatter()}').format(isoUtcStringToLocalTimeOnly(dateTime));
  }

  static int expireDifferanceInDays(DateTime dateTime) {
    int day = dateTime.difference(DateTime.now()).inDays;
    return day;
  }

  static int countDays(DateTime ? dateTime) {
    final startDate = dateTime!;
    final endDate = DateTime.now();
    final difference = endDate.difference(startDate).inDays;
    return difference;
  }

  static String convert24HourTimeTo12HourTimeWithDay(DateTime time, bool isToday) {
    if(isToday){
      return DateFormat('\'Today at\' ${_timeFormatter()}').format(time);
    }else{
      return DateFormat('\'Yesterday at\' ${_timeFormatter()}').format(time);
    }
  }

  static String convertStringTimeToDateTime (DateTime time){
    return DateFormat('EEE \'at\' ${_timeFormatter()}').format(time.toLocal());
  }

  static String dateStringMonthYear(DateTime ? dateTime) {
    return DateFormat('d MMM,y').format(dateTime ?? DateTime.now());
  }

  static String stringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime).toLocal());
  }

  static String stringToMDY(String dateTime) {
    return DateFormat('MM/dd/yyyy').format(DateTime.parse(dateTime).toLocal());
  }

  static DateTime stringToDateTimeMDY(String dateTime) {
    return DateFormat('MM/dd/yyyy').parse(dateTime).toLocal();
  }

  static DateTime isoUtcStringToLocalDateOnly(String dateTime) {
    return DateFormat('yyyy-MM-dd').parse(dateTime, true).toLocal();
  }

  static String dateMonthYearTime(DateTime ? dateTime) {
    return DateFormat('d MMM, y ${_timeFormatter()}').format(dateTime!);
  }

  static DateTime isoUtcStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateTime.parse(dateTime).toLocal());
  }

  static String isoStringToLocalString(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateTime).toLocal());
  }

  ///Todo: working on subscription

  static String utcToDate(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateTime.parse(dateTime));
  }

  static int differenceInDaysIgnoringTime(DateTime dateTime1, DateTime? dateTime2) {
    DateTime date1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime date2;
    if(dateTime2 != null) {
      date2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
    } else {
      date2 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }
    return date1.difference(date2).inDays;
  }

  static String localDateToMonthDateSince(DateTime dateTime) {
    return DateFormat('MMM d, yyyy ').format(dateTime.toLocal());
  }

  static String utcToDateTime(String dateTime) {
    return DateFormat('dd MMM, yyyy h:mm a').format(DateTime.parse(dateTime).toLocal());
  }

}
