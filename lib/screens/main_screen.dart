import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/devel.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:hair_designer_sales_manage/screens/calendar.dart';
import 'package:hair_designer_sales_manage/screens/statistics_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isLoaded = false;

  static const routeCalendar = "/";
  static const routeStatistics = "/statistics";
  static const routeSettings = "/settings";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  void _loading() async {
    myDB = MyDB();
    await myDB.readMyDB();
    myConfig = MyConfig();
    await myConfig.readMyConfig();
    setState(() {
      _isLoaded = true;
    });
  }

  MaterialPageRoute _onGenerateRoute(RouteSettings setting) {
    if (setting.name == routeCalendar) {
      return MaterialPageRoute<dynamic>(
          builder: (context) => Calendar(), settings: setting);
    }
    else if (setting.name == routeStatistics) {
      print(routeStatistics);
      return MaterialPageRoute<dynamic>(
          builder: (context) => Statistics(), settings: setting);
    }
    else if (setting.name == routeSettings) {
      print(routeSettings);
      return MaterialPageRoute<dynamic>(
          builder: (context) => Calendar(), settings: setting);
    }
    else {
      throw Exception('Unknown route: ${setting.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: MediaQuery
                .of(context)
                .size
                .height / 12,
            title: Text('디자이너 매출 관리'),
            elevation: 0,
            actions: [
              IconButton(onPressed: () {
                _navigatorKey.currentState!.pushReplacementNamed(routeCalendar);
              }, icon: Icon(Icons.calendar_month)),
              IconButton(onPressed: () {
                _navigatorKey.currentState!.pushReplacementNamed(routeStatistics);
              }, icon: Icon(Icons.bar_chart_sharp)),
              IconButton(onPressed: () {
                showToast('아직 지원하지 않는 기능입니다.'); // TODO

              }, icon: Icon(Icons.settings)),
            ],
          ),
          body: _isLoaded
              ? Navigator(
              key: _navigatorKey,
              initialRoute: routeCalendar,
              onGenerateRoute: _onGenerateRoute)
              : Center(
            child: SpinKitRing(
              color: Colors.indigo,
            ),
          )),
    );
  }
}
