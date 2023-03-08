
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:snn/data/weatherdata.dart';

class WeatherApi {

  final BASE_URL = "http://apis.data.go.kr";

  final String key = "YjpP%2Fz17lwWN1TmWQew3tkEZ2rdkNSi2SAFwD4eIyZWyznujBX2k5rhdtaPBL3xeEep9rIGgCm4ggIfI%2Fnv1xA%3D%3D";

  Future<List<Weather>> getWeather(int x, int y, int date, String base_time) async {
    String url = "$BASE_URL/1360000/VilageFcstInfoService_2.0/getVilageFcst?"
        "serviceKey=$key&pageNo=1&numOfRows=10&dataType=json&"
        "base_date=$date&base_time=$base_time&nx=$x&ny=$y";


    final response = await http.get(url);

    List<Weather> weather = [];

    if(response.statusCode == 200){
      // 정상으로 진행됨
      String body = utf8.decode(response.bodyBytes);
      print(body);

      var res = json.decode(body) as Map<String, dynamic>;

      List<dynamic> _data = [];

      _data = res["response"]["body"]["items"]["item"] as List<dynamic>;

      final data = groupBy(_data, (obj) => "${obj["fcstTime"]}").entries.toList();

      for(final _r in data){

        final _data = {
          "fcstTime": _r.key,
          "fcstDate": _r.value.first["fcstDate"]
        };

        for(final _d in _r.value){
          _data[_d["category"]] = _d["fcstValue"];
        }

        final w = Weather.fromJson(_data);
        weather.add(w);
      }

      return weather;

    }else{
      return [];
    }
  }
}