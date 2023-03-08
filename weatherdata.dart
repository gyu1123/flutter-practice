
class Weather{
  String date;
  int time;
  int pop;
  int pty;
  String pcp;
  int sky;
  double wsd;
  int tmp;
  int reh;

  Weather({this.date, this.time, this.pop, this.pty, this.pcp, this.sky,
  this.wsd, this.tmp, this.reh});

  factory Weather.fromJson(Map<String, dynamic> data){

    return Weather(
      date: data["fcstDate"],
      time: int.tryParse(data["fcstTime"] ?? "") ?? 0,
      pop: int.tryParse(data["POP"] ?? "") ?? 0,
      pty: int.tryParse(data["PTY"] ?? "") ?? 0,
      pcp: data["PCP"] ?? "",
      sky: int.tryParse(data["SKY"] ?? "") ?? 0,
      wsd: double.tryParse(data["WSD"] ?? "") ?? 0,
      tmp: int.tryParse(data["TMP"] ?? "") ?? 0,
      reh: int.tryParse(data["REH"] ?? "") ?? 0,
    );
  }
}

class LocationData {
  String name;
  int x;
  int y;
  double lat;
  double lng;

  LocationData({this.name, this.x, this.y, this.lat, this.lng});

}











