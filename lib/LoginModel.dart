import 'package:json_annotation/json_annotation.dart';


class LoginModel{
    final String username;
    final String password;

    LoginModel(this.username, this.password);

    @override
    String toString() {
        return username+":"+password;
    }


}