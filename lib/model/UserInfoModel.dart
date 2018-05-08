class UserInfoModel{
    String userId;

    String nick;

    String email;

    String avatar;

    String password;

    int gender;

    bool enable;

    UserInfoModel(this.userId, this.nick, this.email, this.avatar,
            this.password, this.gender, this.enable);

    UserInfoModel.fromJson(Map<String, dynamic> json)
        :this.userId = json['userId'], this.nick = json['nick'], this.email = json['email'], this.avatar = json['avatar'],
                this.password = json['password'], this.gender = json['gender'], this.enable = json['enable'];

    Map<String, dynamic> toJson() =>
            {
                "userId": userId,
                "nick": nick,
                "email": email,
                "avatar": avatar,
                "password": password,
                "gender": gender,
                "enable": enable
            };
}