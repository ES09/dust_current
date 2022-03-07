import 'package:dust_forecast/data/dust.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DustApi {
  final String BASE_URL = "http://apis.data.go.kr";

  final String KEY = "발급 받은 Encode Key 입력";

  Future<List<Dust>> getDustDate(String stationName) async {
    String url = "$BASE_URL/B552584/ArpltnInforInqireSvc/"
        "getMsrstnAcctoRltmMesureDnsty?"
        "serviceKey=$KEY&"
        "returnType=json&numOfRows=100&pageNo=1&"
        "stationName=${Uri.encodeQueryComponent(stationName)}"
        "&dataTerm=DAILY&ver=1.0";

    final response = await http.get(url);

    print('============== Response status: ${response.statusCode}');

    if(response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String, dynamic>;

      List<Dust> data = [];
      // {"so2Grade":"1","coFlag":null,
      // "khaiValue":"112","so2Value":"0.004",
      // "coValue":"0.4","pm25Flag":null,
      // "pm10Flag":null,"pm10Value":"93",
      // "o3Grade":"2","khaiGrade":"3",
      // "pm25Value":"26","no2Flag":null,
      // "no2Grade":"1","o3Flag":null,
      // "pm25Grade":"3","so2Flag":null,
      // "dataTime":"2022-03-04 15:00",
      // "coGrade":"1","no2Value":"0.016",
      // "pm10Grade":"2","o3Value":"0.070"},
      for(final _res in res["response"]["body"]["items"]) {
        final m = Dust.fromJson(_res as Map<String, dynamic>);
        data.add(m);
      }

      return data;

    } else {
      return [];
    }
  }
}