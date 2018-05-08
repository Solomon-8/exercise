import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exercise/main.dart';
import 'package:flutter/material.dart';




class RegisterPage extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        return new RegisterWidget();
    }

}


class RegisterWidget extends State<RegisterPage>{
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    final GlobalKey<FormFieldState<String>> _passwordForm = new GlobalKey<FormFieldState<String>>();
    String email;
    String username;
    String password;
    String retryPassword;
    int gender = 0;
    bool _autovalidate = false;
    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(title: new Center(child: new Text("注册",),),backgroundColor: Colors.black12,),
            body: new Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: new SingleChildScrollView(
                    child: new Column(
                        children: <Widget>[
                            new TextFormField(
                                decoration: const InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    icon: const Text("    邮    箱"),
                                    hintText: '请输入您的邮箱',
                                ),
                                onSaved: (String value){
                                    email = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24.0,),
                            new TextFormField(
                                decoration: const InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    icon: const Text("  用 户 名"),
                                    hintText: '请输入您的姓名',
                                ),
                                onSaved: (String value){
                                    username = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24.0,),
                            new TextFormField(
                                decoration: const InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    icon: const Text("    密    码"),
                                    hintText: '请输入至少5位密码',
                                ),
                                validator: validatePassword,
                                key: _passwordForm,
                                onSaved: (String value){
                                    password = value;
                                },
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24.0,),
                            new TextFormField(
                                decoration: const InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    icon: const Text("确认密码"),
                                    hintText: '请输入您的密码',
                                ),
                                onFieldSubmitted: (String value){
                                    password = value;
                                },
                                obscureText: true,
                                validator: _validateRetryPassword,
                                keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24.0,),
                            new Row(
                                children: <Widget>[
                                    new Text("   性   别   :"),
                                    const SizedBox(width: 40.0,),
                                    new Radio(value: 0, groupValue: gender, onChanged: _handleSelectBox,),
                                    new Text("男"),
                                    const SizedBox(width: 40.0,),
                                    new Radio(value: 1, groupValue: gender, onChanged: _handleSelectBox),
                                    new Text("女"),
                                ],
                            ),
                            const SizedBox(height: 24.0,),
                            new RaisedButton(
                                onPressed: (){doRegister(context);},
                                color: Colors.white,
                                child: new Text("注册"),
                                padding: const EdgeInsets.only(left: 120.0,right: 120.0),
                            ),
                            const SizedBox(height: 24.0,),
                        ],
                    ),
                    padding: const EdgeInsets.only(top: 48.0,left: 15.0,right: 15.0),
                )
            ),
        );
    }


    String _validateRetryPassword(String value){
        final FormFieldState<String> formState = _passwordForm.currentState;
        if (formState.value == null || formState.value.isEmpty)
            return '请输入密码';
        if (formState.value != value)
            return '输入的密码不匹配';
        return null;
    }

    void _handleSelectBox(int value){
        setState((){
            gender = value;
        });
    }

    Future doRegister(context)async {
        final FormState formState = _formKey.currentState;
        if(!formState.validate()){
            _autovalidate = true;
        }else{
            formState.save();
            String register = domain+"/register";
            String post = json.encode({"email":email,"username":username,"password":password,"gender":gender});
            print(post);
            String result;
            await http.post(register,body: post,headers: {'Content-Type':'application/json'}).then((response){
                print("Response body : ${response.body}");
                print("Response Code : ${response.statusCode}");
                result = response.body;
            });
            var response = getFromJson(result);
            if(response != null && response.success == true){
                loginApp(response.data);
            }else{
                showError(context, response.errMessage);
            }
        }
    }
}

String validatePassword(String value){
    if(value.isEmpty){
        return "请输入密码";
    }else if(value.length < 5){
        return "至少输入5位数的密码";
    }else{
        return null;
    }
}

