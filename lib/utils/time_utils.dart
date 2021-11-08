/*  时间戳转字符串
* timestamp 时间戳
* formart ："y-m":年和月之间的符号,
* "m-d":月和日之间的符号
* "h-m":时和分之间的符号,
* "m-s":分和秒之间的符号；
* "m-a":是否显示上午和下午
*/
import 'package:untitled/basic/include.dart';

const OneMinuteMILL = 1000 * 60;
const OneHourMILL = OneMinuteMILL * 60; //一小时
const OneDayMILL = OneHourMILL * 24; //一天
const OneWeekMILL = OneDayMILL * 7; //一周
const OneMoonMILL = OneDayMILL * 30; //一月
const OneYearMILL = OneDayMILL * 365; //一年

class TimeUtils {
  static String dateAndTimeToString(int? timestamp) {
    if (timestamp == null || timestamp == "") {
      return "";
    }
    logger.i('$timestamp ---${DateTime.now()}');
    String targetString = "";
    int timeDiff = DateTime.now().millisecondsSinceEpoch - timestamp;
    logger.i(timeDiff);
    if (timeDiff < OneMinuteMILL * 3) {
      return "刚刚";
    } else if (timeDiff < OneDayMILL) {
      return "${(timeDiff / OneHourMILL).truncate()}小时以前";
    } else if (timeDiff < OneWeekMILL) {
      return "${(timeDiff / OneDayMILL).truncate()}天以前";
    } else if (timeDiff < OneMoonMILL) {
      return "一周以前";
    } else if (timeDiff < OneYearMILL) {
      return "一月以前";
    } else if (timeDiff >= OneYearMILL) {
      return "一年以前";
    }

    return targetString;
  }
}
