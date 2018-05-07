import 'dart:async';

import 'package:exercise/DatabaseHelper.dart';
import 'package:exercise/ResponseModel.dart';
import 'package:exercise/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:path/path.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new LoginWidget();
  }

}



class LoginWidget extends State<LoginPage>{
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String email = "";
    String password = "";
    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            body: new Form(
                    key: _formKey,
                    child: new SingleChildScrollView(
                        child: new Column(
                            children: <Widget>[
                                new Center(
                                    child: new Text("共享体育 ",
                                        style: new TextStyle(fontSize: 48.0),
                                    ),
                                ),
                                const SizedBox(height: 48.0,),
                                new TextFormField(
                                    decoration: const InputDecoration(
                                        border: const UnderlineInputBorder(),
                                        icon: const Text("邮箱"),
                                        hintText: '请输入您的邮箱',
                                    ),
                                    onSaved: (String value){
                                        email = value;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 48.0,),
                                new TextFormField(
                                    decoration: const InputDecoration(
                                        border: const UnderlineInputBorder(),
                                        icon: const Text("密码"),
                                        hintText: '请输入您的密码',
                                    ),
                                    onSaved: (String value){
                                        password = value;
                                    },
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 64.0,),
                                new RaisedButton(
                                    onPressed: (){
                                        doLogin(context);
                                    },
                                    child: new Text("登录"),
                                    padding: const EdgeInsets.only(left: 120.0,right: 120.0),
                                ),
                                const SizedBox(height: 64.0,),
                                new RaisedButton(
                                    onPressed: (){doRegister(context);},
                                    child: new Text("注册"),
                                    padding: const EdgeInsets.only(left: 120.0,right: 120.0),
                                )
                            ],
                        ),
                        padding: const EdgeInsets.only(top: 48.0,left: 15.0,right: 15.0),
            )
            )
        );
    }


    Future doLogin(context)async {
        final FormState form = _formKey.currentState;
        print("it's worked!");
        form.save();
        String login = domain + "/login";
        String post = json.encode({"username":email,"password":password});
        String result = "";
        print(post);
        print("nice!");
        await http.post(login,body: post,headers: {'Content-Type':'application/json'}).then((response){
            print("Response body : ${response.body}");
            print("Response Code : ${response.statusCode}");
            result = response.body;
        });
        print(result);
        Map resultMap = json.decode(result);
        var results = ResponseModel.fromJson(resultMap);
        print("it's the parse result :"+ results.toString());
        if(results.success == true){
            cookie = join(cookie+results.data);
            DatabaseHelper.saveCookie(cookie);
            runApp(new MaterialApp(
                title: '共享体育',
                home:new homePage(),
                routes: {
                    '/loginPage':(BuildContext context) => LoginPage(),
                },
            ));
        }else{
            showDialog(context: context,builder: (BuildContext context) =>
            new AlertDialog(
                content: new Text(results.errMessage),
                actions: <Widget>[
                    new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Center(child: const Text('确定')))
                ],
            ),
            );
        }
    }


    Future doRegister(context)async {
        String cookie = await DatabaseHelper.getCookie();
        showDialog(context: context,builder:(BuildContext context) =>
        new AlertDialog(
            content: new Text(cookie),
            actions: <Widget>[
                new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Center(child: const Text('确定')))
            ]
            ,)
        );
    }

}