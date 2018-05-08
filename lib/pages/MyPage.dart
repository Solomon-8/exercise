import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exercise/main.dart';
import 'package:exercise/utils/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:exercise/pages/LoginPage.dart';
import 'package:exercise/pages/RegisterPage.dart';

class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MyWidget();
  }
}


class MyWidget extends State<MyPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
            children: <Widget>[
                new Expanded(child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        new Container(
                            child: new Row(
                                children: <Widget>[
                                    new Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: new BoxDecoration(shape: BoxShape.circle,image: const DecorationImage(image: const NetworkImage("http://106.14.157.233:8080/jiaoyuPage/zach.jpg"))),
                                    ),
                                    const SizedBox(width: 24.0),
                                    new Center(child: new Text(nick,style: new TextStyle(fontSize: 26.0),))
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                            ),
                            decoration: new BoxDecoration(border: new Border(bottom: const BorderSide(color: Colors.black12,))),
                            height: 120.0,
                            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        ),
                        const SizedBox(height: 24.0,),
                        new Column(
                            children: <Widget>[
                                new GestureDetector(
                                    child: new Container(
                                        child: new Row(children: <Widget>[
                                            new Center(child: new Text("活动记录",style: new TextStyle(fontSize: 26.0))),
                                            new Icon(Icons.keyboard_arrow_right),
                                        ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        decoration: new BoxDecoration(border: new Border(top: const BorderSide(color: Colors.black12,),bottom: const BorderSide(color: Colors.black12,))),
                                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                    ),
                                    onTap: (){print("Hello World");showActivities(context);},
                                ),
                                const SizedBox(height: 15.0,),
                                new GestureDetector(
                                    child:  new Container(
                                        child: new Row(children: <Widget>[
                                            new Center(child: new Text("修改密码",style: new TextStyle(fontSize: 26.0),)),
                                            new Icon(Icons.keyboard_arrow_right),
                                        ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        decoration: new BoxDecoration(border: new Border(top: const BorderSide(color: Colors.black12,),bottom: const BorderSide(color: Colors.black12,))),
                                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                    ),
                                    onTap: (){print("show A!");modifyPassword(context);print('d');},
                                ),
                            ],
                        ),
                        const SizedBox(height: 24.0,),
                        new RaisedButton(
                            child: new Text("退出登录"),
                            onPressed: (){doLogout();},
                            padding: const EdgeInsets.only(left: 120.0,right: 120.0),
                            color: Colors.white,
                        ),
                        const SizedBox(height: 1.0,)
                    ],
                ),)
            ],
        )
    );
  }

  doLogout()async {
      print("press logout.");
      cookie = originCookie;
      await DatabaseHelper.saveInfo();
      runApp(new MaterialApp(
          title: '共享体育',
          home:new LoginPage(),
          routes: {
              '/homePage':(BuildContext context) => homePage(),
              '/registerPage':(BuildContext context) => RegisterPage(),
          },
      ));
  }

  showActivities(BuildContext context){
        Navigator.of(context).pushNamed('/activitiesRecorder');
  }
  final GlobalKey<FormState> _modifyKey = new GlobalKey<FormState>();
  String password;
  String newPassword;
  bool autoCheck = false;
  modifyPassword(BuildContext context){
        showDialog(context: context,builder: (BuildContext context) =>
               new AlertDialog(
                   title: const Text('输入原密码和新密码.'),
                   content: new Form(
                       child: new SingleChildScrollView(
                           child:new Column(
                               children: <Widget>[
                                   new TextFormField(
                                       decoration: const InputDecoration(
                                           border: const UnderlineInputBorder(),
                                           hintText: '请输入原密码',
                                       ),
                                       validator: validatePassword,
                                       onSaved: (String value){
                                           password = value;
                                       },
                                       obscureText: true,
                                       keyboardType: TextInputType.emailAddress,
                                   ),
                                   new TextFormField(
                                       decoration: const InputDecoration(
                                           border: const UnderlineInputBorder(),
                                           hintText: '请输入至少5位的新密码',
                                       ),
                                       onSaved: (String value){
                                           newPassword = value;
                                       },
                                       validator: validatePassword,
                                       keyboardType: TextInputType.emailAddress,
                                   ),
                               ],
                           ),
                       ),
                       key: _modifyKey,
                       autovalidate: autoCheck,
                   ),
                   actions: <Widget>[
                       new FlatButton(
                               child: const Text('确定'),
                               onPressed: () { doModify(); }
                       ),
                       new FlatButton(
                               child: const Text('取消'),
                               onPressed: () {Navigator.pop(context);}
                       )
                   ],
               )
        );
  }

  doModify() async{
      FormState formState = _modifyKey.currentState;
      if(!formState.validate()){
          autoCheck = true;
      }else{
          formState.save();
          String modifyPassword = domain + "/modifyPassword";
          String post = json.encode({"password":password,"newPassword":newPassword});
          print(post);
          String result;
          await http.post(modifyPassword,body: post,headers: {'Content-Type':'application/json','cookie':cookie}).then((response){
              print("Response body : ${response.body}");
              print("Response Code : ${response.statusCode}");
              result = response.body;
          });
          var response = getResponseFromJson(result);
          if(response != null && response.success == true){
              shwoSuccess(context,"修改密码成功，你可以使用新密码登录了。");
          }else{
              showError(context, response.errMessage);
          }
      }
  }
}