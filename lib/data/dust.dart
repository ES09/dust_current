class Dust {
  int pm10;
  int pm025;
  int khai;
  String dataTime;
  double so;
  double co;
  double no;
  double o3;

  Dust({this.pm10, this.pm025, this.khai, this.dataTime, this.so, this.co, this.no, this.o3});

  factory Dust.fromJson(Map<String, dynamic> data){
    return Dust(
      pm10: int.tryParse(data["pm10Value"] ?? "") ?? 0,
      pm025: int.tryParse(data["pm25Value"] ?? "") ?? 0,
      khai: int.tryParse(data["khaiGrade"] ?? "") ?? 0,
      dataTime: data["dataTime"] ?? "",
    );
  }
}