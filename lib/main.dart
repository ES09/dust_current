import 'package:dust_forecast/data/dustApi.dart';
import 'package:flutter/material.dart';

import 'data/dust.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Color> colors = [
    Color(0xFF0077c2),
    Color(0xFF009ba9),
    Color(0xFFFe6300),
    Color(0xFFd80019)
  ];

  List<String> icons = [
    "assets/img/happy.png",
    "assets/img/sad.png",
    "assets/img/bad.png",
    "assets/img/angry.png",
  ];

  List<String> status = ["좋음", "보통", "나쁨", "매우나쁨"];

  String stationName = "금천구";
  List<Dust> data = [];

  int getStatus(Dust dust) {
    if(dust.pm10 > 150) {
      return 3; //매우나쁨
    } else if(dust.pm10 > 80) {
      return 2;
    } else if(dust.pm10 > 30) {
      return 1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getDustApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String _location = await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => LocationPage())
          );
          if(_location != null) {
            stationName = _location;
            getDustApiData();
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage(){
    if(data.isEmpty) {
      return Container();
    }

    int statusFromApi = getStatus(data.first);

    return Container(
      color: colors[statusFromApi],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 50,),
          Text("현재 위치", textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(height: 12,),
          Text("[$stationName]", textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Container(height: 30,),
          Container(child :
            Image.asset(icons[statusFromApi], fit: BoxFit.contain,),
            width: 250,
            height: 250,
          ),
          Container(height: 30,),
          Text(status[statusFromApi], textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(height: 12,),
          Text("통합 환경 대기 지수 : ${data.first.khai}", textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Expanded(child: Container(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(data.length, (idx) {
                  Dust dust = data[idx];
                  int _status = getStatus(dust);

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children : [
                        Text(dust.dataTime.replaceAll(" ", "\n"), style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                        Container(height: 8),
                        Container(child:
                          Image.asset(icons[_status], fit: BoxFit.contain, ),
                          height: 50,
                          width: 50,
                        ),
                        Container(height: 8),
                        Text("${dust.pm10}ug/m2", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                      ]
                    )
                  );
                }
              ),
            )
          )),
          Container(height: 30,)
        ],
      ),
    );
  }

  void getDustApiData() async {
    DustApi api = DustApi();
    data = await api.getDustDate(stationName);
    data.removeWhere((element) => element.pm10 == 0);
    setState(() {});
  }
}

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    "강남구",
    "강동구",
    "구로구",
    "금천구",
    "동작구",
    "마포구",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(locations.length, (idx) {
            return ListTile(
              title: Text(locations[idx]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(locations[idx]);
              },
            );
          }
        ),
      ),
    );
  }
}
