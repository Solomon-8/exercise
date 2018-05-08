import 'dart:convert';

import 'package:exercise/pages/ActivitiesRecorderPage.dart';
import 'package:exercise/pages/ActivityPage.dart';
import 'package:exercise/pages/AddActivityPage.dart';
import 'package:exercise/pages/MyPage.dart';
import 'package:exercise/utils/DatabaseHelper.dart';
import 'package:exercise/pages/LoginPage.dart';
import 'package:exercise/pages/RegisterPage.dart';
import 'package:exercise/model/ResponseModel.dart';
import 'package:exercise/model/UserInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

void main()async{
  await DatabaseHelper.init();
  checkFlag = await DatabaseHelper.checkCookie();
  runApp(new MyApp());
}
var domain = "http://106.14.157.233:8888";
String cookie = "session_id=";
String originCookie = "session_id=";
bool checkFlag;
String nick = "我是你爸爸";
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      if(checkFlag){
        return new MaterialApp(
          title: '共享体育',
          home:new LoginPage(),
          routes: {
            '/homePage':(BuildContext context) => homePage(),
            '/registerPage':(BuildContext context) => RegisterPage(),
          },
        );
      }else{
        return new MaterialApp(
          title: '共享体育',
          home:new homePage(),
          routes: {
            '/loginPage':(BuildContext context) => LoginPage(),
            '/activitiesRecorder':(BuildContext context) => ActivitiesRecorderPage(),
          },
        );
      }
  }
}

class homePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _homePageState();
  }
}

class _homePageState extends State<homePage> with TickerProviderStateMixin{

  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;


  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon:const Icon(Icons.email),
        title: "活动",
        color: Colors.white,
        vsync: this,
      ),
      new NavigationIconView(
        icon:const Icon(Icons.email),
        title: "发布",
        color: Colors.white,
        vsync: this,
      ),
      new NavigationIconView(
        icon:const Icon(Icons.email),
        title: "我的",
        color: Colors.white,
        vsync: this,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: _navigationViews.map((NavigationIconView i) => i.item).toList(),
      currentIndex: _currentIndex,
      onTap: (int index){
        setState((){
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );




    return new Scaffold(
      appBar: getAppBar(_currentIndex),
      body: getBody(_currentIndex),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget getAppBar(int index){
    if(index == 0){
      return new AppBar(title: new Center(child: new Text("活动"),),);
    }else if(index == 1){
      return new AppBar(title: new Center(child: new Text("发布"),),);
    }else{
      return new AppBar(title: new Center(child: new Text("我的"),),);
    }
  }

  Widget getBody(int index){
    if(index == 0){
      return new ActivityPage();
    }else if(index == 1){
      return new AddActivityPage();
    }else{
      return new MyPage();
    }
  }

}


class NavigationIconView{
  final Widget _icon;
  final String _title;
  final Color _color;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  }): _icon = icon,
            _title = title,
            _color = color,
            item = new BottomNavigationBarItem(icon: icon,title: new Text(title),backgroundColor: color),
            controller = new AnimationController(duration: kThemeAnimationDuration,vsync: vsync){
    _animation = new CurvedAnimation(parent: controller, curve: const Interval(0.5, 1.0,curve: Curves.fastOutSlowIn));
  }


}


ResponseModel getResponseFromJson(String result){
  Map resultMap = json.decode(result);
  return ResponseModel.fromJson(resultMap);
}

UserInfoModel getUserInfoFromJson(String result){
  Map resultMap = json.decode(result);
  return UserInfoModel.fromJson(resultMap);
}

showError(BuildContext context,String error){
  showDialog(context: context,builder: (BuildContext context) =>
  new AlertDialog(
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Center(child: const Text('确定')))
    ],
  ),
  );
}

shwoSuccess(BuildContext context,String content){
  showDialog(context: context,builder: (BuildContext context) =>
  new AlertDialog(
    content: new Text(content),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Center(child: const Text('确定')))
    ],
  ),
  );
}

getUserInfo() async {
  String getUserinfo = domain+"/getUserInfo";
  String result;
  await http.get(getUserinfo,headers:{'Content-Type':'application/json','cookie':cookie}).then((response){
    print("Response body : ${response.body}");
    print("Response Code : ${response.statusCode}");
    result = response.body;
  });
  print(result);
  var results = getResponseFromJson(result);
  var userinfo = getUserInfoFromJson(results.data);
  nick = userinfo.nick;
}

loginApp(String receiveCookie){
  cookie = join(cookie+receiveCookie);
  DatabaseHelper.saveInfo();
  runApp(new MaterialApp(
    title: '共享体育',
    home:new homePage(),
    routes: {
      '/loginPage':(BuildContext context) => LoginPage(),
      '/activitiesRecorder':(BuildContext context) => ActivitiesRecorderPage(),
    },
  ));
}




