


class LoginModel{
    final String username;
    final String password;

    LoginModel(this.username, this.password);

    @override
    String toString() {
        return username+":"+password;
    }


}