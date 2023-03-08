import 'package:flutter/material.dart';
import 'package:snn/data/Wapi.dart';
import 'package:snn/data/utils.dart';
import 'package:snn/data/weatherdata.dart';
import 'location.dart';




class Weatherpage extends StatefulWidget {
  Weatherpage({Key key}): super(key: key);

  @override
  _Weatherpage createState() => _Weatherpage();
}

class _Weatherpage extends State<Weatherpage> {
  List<String> clothes = ["assets/img/shirt.png", "assets/img/short.png", "assets/img/pants.png"];
  List<Weather> weather =[];
  Weather current;
  LocationData location = LocationData(lat: 37.498122, lng: 127.027565, name: "양천구", x: 0, y: 0);
  List<String> sky = [
    "assets/img/sky1.png",
    "assets/img/sky2.png",
    "assets/img.sky3.png",
    "assets/img/sky4.png"];
  List<String> status = [
    "아주 맑음",
    "맑음",
    "흐림",
    "비"];

  List<Color> color = [
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff),
    Color(0xffffffff)
  ];
  int level = 0;

  void getWeather() async {
    final api = WeatherApi();
    final now = DateTime.now();
    Map<String, int> xy = Utils.latLngToXY(location.lat, location.lng);


    int time2 = int.parse("${now.hour}10");
    String _time = "";

    if(time2 > 2300){
      _time = "2300";
    }else if(time2 > 2000){
      _time = "2000";
    }else if(time2 > 1700){
      _time = "1700";
    }else if(time2 > 1400){
      _time = "1400";
    }else if(time2 > 1100){
      _time = "1100";
    }else if(time2 > 800){
      _time = "0800";
    }else if(time2 > 500){
      _time = "0500";
    }else {
      _time = "0200";
    }



    weather = await api.getWeather(xy["nx"], xy["ny"], Utils.getFormatTime(DateTime.now()), _time);

    int time = int.parse("${now.hour}00");
    weather.removeWhere((w) => w.time < time);
    current = weather.first;

    level = getLevel(current);
    setState(() {});

  }

  int getLevel(Weather w){
    if(w.sky > 8){
      return 3;
    }
    else if(w.sky > 5){
      return 2;
    }else if(w.sky > 2){
      return 1;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: color[level],
      body: weather.isEmpty ? Container(child: Text("")) :
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 50,),
            Text("${location.name}", textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20
              ),),
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Image.asset(sky[level]),
              alignment: Alignment.centerRight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("${current.tmp}°C", style: TextStyle(
                    color: Colors.black,
                    fontSize: 28
                )),
                Column(
                  children: [
                    Text("${Utils.stringToDateTime(current.date).month}월 ${Utils.stringToDateTime(current.date).day}일", style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                    )),
                    Text(status[level], style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                    )),
                  ],
                )
              ],
            ),
            Container(height: 30,),
            Text("오늘도 좋은 하루 되세요"),
            Expanded(child: Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      weather.length,
                          (idx){

                        final w = weather[idx];
                        int _level = getLevel(w);

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${w.tmp}°C", style: TextStyle(fontSize: 10, color: Colors.black),),
                              Text("${w.pop}%", style: TextStyle(fontSize: 10, color: Colors.black)),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(sky[_level]),
                              ),
                              Text("${w.time}", style: TextStyle(fontSize: 10, color: Colors.black)),
                            ],
                          ),
                        );
                      }
                  ),
                ))),
            Container(height: 80,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LocationData data = await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => LocationPage())
          );
          if(data != null){
            location = data;
            getWeather();
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}