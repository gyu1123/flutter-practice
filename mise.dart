class Mise {
  int pm10;
  int pm25;
  int khai;
  String dataTime;
  double so;
  double co;
  double no;
  double o3;

  Mise({this.pm10, this.pm25, this.khai, this.dataTime, this.so, this.co, this.no, this.o3});

  factory Mise.fromJson(Map<String, dynamic> data){
    return Mise(
      pm10: int.tryParse(data["pm10Value"] ?? "") ?? 0,
      pm25: int.tryParse(data["pm25Value"] ?? "") ?? 0,
      khai: int.tryParse(data["khaiGrade"] ?? "") ?? 0,
      dataTime: data["dataTime"] ?? "",
    );
  }
}