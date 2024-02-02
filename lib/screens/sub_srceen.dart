import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/my_widget/my_calendar/my_calendar.dart';
import 'package:hair_designer_sales_manage/screens/main_item.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const routeA = "/";

  MaterialPageRoute _onGenerateRoute(RouteSettings setting) {
    if (setting.name == routeA) {
      return MaterialPageRoute<dynamic>(
          builder: (context) => MyCalendar(), settings: setting);
    }
    else {
      throw Exception('Unknown route: ${setting.name}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute
    );
  }
}
