import 'dart:math' as math;

class Utils {
  static String makeTwoDigit(int number){
    return number.toString().padLeft(2, "0");
  }

  static int getFormatTime(DateTime time){
    return int.parse("${time.year}${makeTwoDigit(time.month)}${makeTwoDigit(time.day)}");
  }

  static DateTime stringToDateTime(String date){
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));

    return DateTime(year, month, day);
  }
  static Map<String, int> latLngToXY(double v1, double v2) {
    var RE = 6371.00877; // 지구 반경(km)
    var GRID = 5.0; // 격자 간격(km)
    var SLAT1 = 30.0; // 투영 위도1(degree)
    var SLAT2 = 60.0; // 투영 위도2(degree)
    var OLON = 126.0; // 기준점 경도(degree)
    var OLAT = 38.0; // 기준점 위도(degree)
    var XO = 43; // 기준점 X좌표(GRID)
    var YO = 136; // 기1준점 Y좌표(GRID)

    var DEGRAD = math.pi / 180.0;
    var RADDEG = 180.0 / math.pi;

    var re = RE / GRID;
    var slat1 = SLAT1 * DEGRAD;
    var slat2 = SLAT2 * DEGRAD;
    var olon = OLON * DEGRAD;
    var olat = OLAT * DEGRAD;

    var sn = math.tan(math.pi * 0.25 + slat2 * 0.5) /
        math.tan(math.pi * 0.25 + slat1 * 0.5);
    sn = math.log(math.cos(slat1) / math.cos(slat2)) / math.log(sn);
    var sf = math.tan(math.pi * 0.25 + slat1 * 0.5);
    sf = math.pow(sf, sn) * math.cos(slat1) / sn;
    var ro = math.tan(math.pi * 0.25 + olat * 0.5);
    ro = re * sf / math.pow(ro, sn);
    Map<String, int> rs = {};
    // rs['lat'] = v1;
    // rs['lng'] = v2;
    var ra = math.tan(math.pi * 0.25 + (v1) * DEGRAD * 0.5);
    ra = re * sf / math.pow(ra, sn);
    var theta = v2 * DEGRAD - olon;
    if (theta > math.pi) theta -= 2.0 * math.pi;
    if (theta < -math.pi) theta += 2.0 * math.pi;
    theta *= sn;
    rs['nx'] = (ra * math.sin(theta) + XO + 0.5).floor();
    rs['ny'] = (ro - ra * math.cos(theta) + YO + 0.5).floor();
    return rs;
  }
}