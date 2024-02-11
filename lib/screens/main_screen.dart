import 'package:flutter/material.dart';
import 'package:hair_designer_sales_manage/items/my_db.dart';
import 'package:hair_designer_sales_manage/screens/sub_srceen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  void _loading() async{
    myDB = MyDB();
    await myDB.readMyDB();
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height/12,
          title: Text('Main Screen'),
          elevation: 0,
        ),
        body: _isLoaded ? SubScreen() : Center(
          child: SpinKitRing(color: Colors.indigo,),
        )
      ),
    );
  }
}
